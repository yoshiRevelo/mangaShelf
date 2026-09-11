//
//  MockAuthRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

final class MockAuthRepository: AuthRepository, @unchecked Sendable {
    
    var loginToken: AuthToken
    var refreshedToken: AuthToken
    var shouldFail: Bool
    var delay: Duration
    private(set) var refreshCallCount = 0
    
    init(
        loginToken: AuthToken = AuthToken(dto: AuthTokenDTO(tokenType: "Bearer", token: "refresh-fake", tokenUse: "refresh", expiresIn: 2_592_000)),
        refreshedToken: AuthToken = AuthToken(dto: AuthTokenDTO(tokenType: "Bearer", token: "access-fake", tokenUse: "access", expiresIn: 3_600)),
        shouldFail: Bool = false,
        delay: Duration = .zero
    ) {
        self.loginToken = loginToken
        self.refreshedToken = refreshedToken
        self.shouldFail = shouldFail
        self.delay = delay
    }

    func register(email: String, password: String) async throws {
        try await simulateWork()
    }

    func login(email: String, password: String) async throws -> AuthToken {
        try await simulateWork()
        return loginToken
    }

    func refreshToken(token: String) async throws -> AuthToken {
        refreshCallCount += 1
        try await simulateWork()
        return refreshedToken
    }

    func userInfo(accessToken: String) async throws -> UserInfo {
        try await simulateWork()
        return UserInfo(id: UUID(), isActive: true, isAdmin: false, role: "user", email: "test@test.com")
    }
    
    func legacyLogin(email: String, password: String) async throws -> AuthToken {
        try await simulateWork()
        return AuthToken(legacyToken: "12345678")
    }
    
    func legacyRefresh(token: String) async throws -> AuthToken {
        try await simulateWork()
        return AuthToken(legacyToken: "87654321")
    }
    
    private func simulateWork() async throws {
        if delay != .zero { try? await Task.sleep(for: delay) }
        if shouldFail { throw APIError.offline }
    }
}
