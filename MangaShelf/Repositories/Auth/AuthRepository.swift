//
//  AuthRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

nonisolated protocol AuthRepository: Sendable {
    func register(email: String, password: String) async throws
    func login(email: String, password: String) async throws -> AuthToken
    func refreshToken(token: String) async throws -> AuthToken
    func userInfo(accessToken: String) async throws -> UserInfo
}

nonisolated final class AuthRepositoryImpl: AuthRepository {
    private let network: any NetworkClient
    
    init(network: any NetworkClient) {
        self.network = network
    }
    
    func register(email: String, password: String) async throws {
        try await network.send(AuthEndpoints.register(email: email, password: password))
    }
    
    func login(email: String, password: String) async throws -> AuthToken {
        let dto = try await network.send(AuthEndpoints.login(email: email, password: password), as: AuthTokenDTO.self)
        return AuthToken(dto: dto)
        
    }
    
    func refreshToken(token: String) async throws -> AuthToken {
        let dto = try await network.send(AuthEndpoints.refreshToken(token), as: AuthTokenDTO.self)
        return AuthToken(dto: dto)
    }
    
    func userInfo(accessToken: String) async throws -> UserInfo {
        try await network.send(AuthEndpoints.userInfo(accessToken: accessToken), as: UserInfo.self)
    }
}
