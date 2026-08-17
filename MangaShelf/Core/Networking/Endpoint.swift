//
//  Endpoint.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import Foundation

nonisolated struct Endpoint: Sendable {
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]
    var body: Data?
    var headers: [String: String]
    var requiresAuth: Bool
    
    init(path: String, method: HTTPMethod = .get, queryItems: [URLQueryItem] = [], body: Data? = nil, headers: [String: String] = [:], requiresAuth: Bool = false) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.headers = headers
        self.requiresAuth = requiresAuth
    }
    
    func makeRequest(with configuration: APIConfiguration, token: String?) throws -> URLRequest {
        let fullURL = configuration.baseURL.appending(path: path)
        
        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: APIConfiguration.Header.contentType)
        }
        
        if requiresAuth, let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: APIConfiguration.Header.authorization)
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    static func jsonBody(_ value: some Encodable) throws -> Data {
        try JSONEncoder().encode(value)
    }
}
