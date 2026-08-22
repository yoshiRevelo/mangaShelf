//
//  NetworkClientTests.swift
//  MangaShelfTests
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation
import Testing
@testable import MangaShelf

@Suite(.serialized)
struct NetworkClientTests {
    private let config = APIConfiguration(baseURL: URL(string: "https://api.test")!)
    
    private func makeClient() -> URLSessionNetworkClient {
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfig)
        return URLSessionNetworkClient(session: session, configuration: config, tokenProvider: nil)
    }
    
    @Test func decodesPaginatedMangaResponse() async throws {
        let json = """
                {"metadata":{"total":1,"page":1,"per":20},"items":[{"score":9.15,"status":"finished","titleEnglish":"Monster","background":null,"demographics":[{"demographic":"Seinen","id":"CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D"}],"sypnosis":"Kenzou Tenma...\\n\\nNine years later...","authors":[{"role":"Story & Art","firstName":"Naoki","id":"54BE174C-2FE9-42C8-A842-85D291A6AEDD","lastName":"Urasawa"}],"chapters":162,"endDate":"2001-12-20T00:00:00Z","themes":[{"theme":"Adult Cast","id":"840867E7-6C60-49CE-8C47-A99AA71A2113"}],"startDate":"1994-12-05T00:00:00Z","id":1,"titleJapanese":"MONSTER","url":"https://myanimelist.net/manga/1/Monster","title":"Monster","volumes":18,"genres":[{"id":"4C13067F-96FF-4F14-A1C0-B33215F24E0B","genre":"Drama"}],"mainPicture":"https://cdn.myanimelist.net/images/manga/3/258224l.jpg"}]}
                """.data(using: .utf8)!
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        
        let client = makeClient()
        let result = try await client.send(Endpoint(path: "list/mangas"), as: PaginatedResponse<Manga>.self)
        
        #expect(result.metadata.total == 1)
        #expect(result.items.first?.title == "Monster")
    }
    
    @Test func throwUnauthorized() async throws {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        let client = makeClient()
        await #expect(throws: APIError.unauthorized) {
            try await client.send(Endpoint(path: "collection/manga"), as: PaginatedResponse<Manga>.self)
        }
    }
    
    @Test func mapServverReasonOnUnexpectedStatus() async throws {
        let errorJSON = #"{"reason":"Something went wrong"}"#.data(using: .utf8)!
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, errorJSON)
        }
        
        let client = makeClient()
        
        do {
            _ = try await client.send(Endpoint(path: "list/mangas"), as: PaginatedResponse<Manga>.self)
            Issue.record("An error was expected")
        } catch let APIError.unexpectedStatus(code, message) {
            #expect(code == 500)
            #expect(message == "Something went wrong")
        }
    }
    
    @Test func throwDecodingErrorONInvalidJSON() async throws {
        let garbage = "This is not a JSON".data(using: .utf8)!
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, garbage)
        }
        
        let client = makeClient()
        await #expect(throws: APIError.self) {
            try await client.send(Endpoint(path: "list/mangas"), as: PaginatedResponse<Manga>.self)
        }
    }
}
