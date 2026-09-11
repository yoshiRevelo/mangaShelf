//
//  URLSessionNetworkClient.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import Foundation

nonisolated final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let tokenProvider: (any AuthTokenProviding)?
    
    init(session: URLSession = .shared, configuration: APIConfiguration = .default, tokenProvider: (any AuthTokenProviding)? = nil) {
        self.session = session
        self.configuration = configuration
        self.tokenProvider = tokenProvider
    }
    
    @discardableResult
    func send<Response>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response where Response : Decodable, Response : Sendable {
        let (data, _) = try await perform(endpoint)
        
        do {
            return try Self.makeDecoder().decode(Response.self, from: data)
        } catch {
            throw APIError.decoding(String(describing: error))
        }
    }
    
    func send(_ endpoint: Endpoint) async throws {
        _ = try await perform(endpoint)
    }
    
    private func perform(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        let token = endpoint.requiresAuth ? try await tokenProvider?.accessToken() : nil

        let request = try endpoint.makeRequest(with: configuration, token: token)
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw APIError.offline
        } catch {
            throw APIError.transport(error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        try validate(httpResponse, data: data)
        return (data, httpResponse)
    }
    
    private func validate(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200..<300: return
        case 401: throw APIError.unauthorized
        default:
            let message = Self.extractServerMessage(from: data)
            throw APIError.unexpectedStatus(code: response.statusCode, message: message)
        }
    }
    
    private static func extractServerMessage(from data: Data) -> String? {
        struct ServerError: Decodable { let reason: String? }
        return try? JSONDecoder().decode(ServerError.self, from: data).reason
    }
    
    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
