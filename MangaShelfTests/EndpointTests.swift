//
//  EndpointTests.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//


import Foundation
import Testing
@testable import MangaShelf

struct EndpointTests {
    private let config = APIConfiguration(baseURL: URL(string: "https://api.test")!)

    @Test func buildsURLWithPathAndQuery() throws {
        let endpoint = Endpoint(path: "list/mangas", queryItems: [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per", value: "20")
        ])
        let request = try endpoint.makeRequest(with: config, token: nil)
        #expect(request.url?.absoluteString == "https://api.test/list/mangas?page=1&per=20")
    }

    @Test func addsBearerOnlyWhenRequiresAuth() throws {
        let secured = try Endpoint(path: "collection/manga", requiresAuth: true).makeRequest(with: config, token: "tok")
        #expect(secured.value(forHTTPHeaderField: "Authorization") == "Bearer tok")

        let open = try Endpoint(path: "list/mangas").makeRequest(with: config, token: "tok")
        #expect(open.value(forHTTPHeaderField: "Authorization") == nil)
    }

    @Test func sendsAppTokenOnlyWhenExplicitlyProvided() throws {
        let withToken = try Endpoint(path: "users", method: .post, headers: [APIConfiguration.Header.appToken: "test-token"])
            .makeRequest(with: config, token: nil)
        #expect(withToken.value(forHTTPHeaderField: "App-Token") == "test-token")

        let without = try Endpoint(path: "list/mangas").makeRequest(with: config, token: nil)
        #expect(without.value(forHTTPHeaderField: "App-Token") == nil)
    }

    @Test func setsJSONContentTypeWhenBodyPresent() throws {
        let body = try Endpoint.jsonBody(["email": "yoshi@example.com", "password": "0987654"])
        let request = try Endpoint(path: "users/login", method: .post, body: body).makeRequest(with: config, token: nil)
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(request.httpMethod == "POST")
    }
    
    @Test func fetchByGenreWithSpace() async throws {
        let network = URLSessionNetworkClient()
        let repository = MangaRepositoryImpl(network: network)
        
        let query = MangaListQuery(page: 1, per: 1, mode: .genre("Award Winning"))
        let manga = try await repository.fetchMangas(query: query)
        #expect(manga.items.count == 1)
    }
}

// MARK: - URLProtocol falso, intercepta cualquier petición, red real cero.

nonisolated final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
