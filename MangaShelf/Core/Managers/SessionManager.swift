//
//  SessionManager.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

actor SessionManager: AuthTokenProviding {
    private let keychain: any KeychainStoring
    private let authRepository: any AuthRepository
    private var accessToken: AuthToken?
    private var refreshTask: Task<AuthToken, Error>?
    
    var hasStoredSession: Bool {
        (try? keychain.read(for: KeychainKey.refreshToken)) != nil
    }
    
    init(keychain: any KeychainStoring = KeychainStore(), authRepository: any AuthRepository) {
        self.keychain = keychain
        self.authRepository = authRepository
    }
    
    func accessToken() async throws -> String? {
        if let accessToken, !accessToken.isExpired {
            return accessToken.token
        }
        
        return try await refreshedAccessToken()?.token
    }
    
    func register(email: String, password: String) async throws {
        try await authRepository.register(email: email, password: password)
    }
    
    func login(email: String, password: String) async throws {
        let refreshToken = try await authRepository.login(email: email, password: password)
        try storeRefreshToken(refreshToken)
        accessToken = nil
    }
    
    func currentUser() async throws -> UserInfo? {
        guard let token = try await accessToken() else { return nil }
        return try await authRepository.userInfo(accessToken: token)
    }
    
    func logout() {
        try? keychain.delete(for: KeychainKey.refreshToken)
        accessToken = nil
        refreshTask = nil
    }
    
    private func refreshedAccessToken() async throws -> AuthToken? {
        
        if let refreshTask { return try await refreshTask.value }
        
        guard let storedRefreshToken = try await loadRefreshToken(), !storedRefreshToken.isExpired else { return nil }
        
        let task = Task<AuthToken, Error> {
            try await authRepository.refreshToken(token: storedRefreshToken.token)
        }
        refreshTask = task
        defer { refreshTask = nil }
        
        let newAccessToken = try await task.value
        accessToken =  newAccessToken
        
        return newAccessToken
    }
    
    private func storeRefreshToken(_ token: AuthToken) throws {
        let data = try JSONEncoder().encode(token)
        try keychain.save(data, for: KeychainKey.refreshToken)
    }
    
    private func loadRefreshToken() async throws -> AuthToken? {
        guard let data = try keychain.read(for: KeychainKey.refreshToken) else { return nil }
        return try JSONDecoder().decode(AuthToken.self, from: data)
    }
}
