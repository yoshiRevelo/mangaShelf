//
//  SessionManagerTests.swift
//  MangaShelfTests
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation
import Testing
@testable import MangaShelf

@Suite("SessionManagerTests")
struct SessionManagerTests {
    @Test func deduplicatesConcurrentRefreshCalls() async throws {
        let authRepository = MockAuthRepository()
        authRepository.delay = .milliseconds(100)
        let sessionManager = SessionManager(keychain: MockKeychainStore(), authRepository: authRepository)

        try await sessionManager.login(email: "a@a.com", password: "12345678")

        async let first = try await sessionManager.accessToken()
        async let second = try await sessionManager.accessToken()
        _ = try await (first, second)

        #expect(authRepository.refreshCallCount == 1)
    }
}
