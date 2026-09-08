//
//  NetworkClient.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import Foundation

nonisolated protocol AuthTokenProviding: Sendable {
    func accessToken() async throws -> String?
}

nonisolated protocol NetworkClient: Sendable {
    @discardableResult
    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response
    func send(_ endpoint: Endpoint) async throws
}
