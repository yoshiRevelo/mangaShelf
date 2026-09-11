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
    
    //MARK: - LegacyToken
    private var legacyToken: AuthToken?
    private var legacyRefreshTokenTask: Task<AuthToken, Error>?
    
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
        
        let legacyTokenRefresh = try await authRepository.legacyLogin(email: email, password: password)
        try storeRefreshToken(legacyTokenRefresh, tokenType: .legacy)
        accessToken = nil
        legacyToken = nil
    }
    
    func currentUser() async throws -> UserInfo? {
        guard let token = try await accessToken() else { return nil }
        return try await authRepository.userInfo(accessToken: token)
    }
    
    func logout() {
        try? keychain.delete(for: KeychainKey.refreshToken)
        accessToken = nil
        refreshTask = nil
        
        try? keychain.delete(for: KeychainKey.legacyToken)
        legacyToken = nil
        legacyRefreshTokenTask = nil
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
    
    private func storeRefreshToken(_ token: AuthToken, tokenType: TokenType = .new) throws {
        let data = try JSONEncoder().encode(token)
        try keychain.save(data, for: tokenType == .new ? KeychainKey.refreshToken : KeychainKey.legacyToken)
    }
    
    private func loadRefreshToken(tokenType: TokenType = .new) async throws -> AuthToken? {
        guard let data = tokenType == .new ? try keychain.read(for: KeychainKey.refreshToken) : try keychain.read(for: KeychainKey.legacyToken) else { return nil }
        return try JSONDecoder().decode(AuthToken.self, from: data)
    }
    
    //MARK: - Legacy functions
    func legacyAccessToken() async throws -> String? {
        if let legacyToken, !legacyToken.isExpired {
            return legacyToken.token
        }
        
        return try await refreshedLegacyAccessToken()?.token
    }
    
    private func refreshedLegacyAccessToken() async throws -> AuthToken? {
        
        if let legacyRefreshTokenTask { return try await legacyRefreshTokenTask.value }
        
        guard let storedRefreshToken = try await loadRefreshToken(tokenType: .legacy), !storedRefreshToken.isExpired else { return nil }
        
        let task = Task<AuthToken, Error> {
            try await authRepository.legacyRefresh(token: storedRefreshToken.token)
        }
        legacyRefreshTokenTask = task
        defer { legacyRefreshTokenTask = nil }
        
        let newAccessToken = try await task.value
        try storeRefreshToken(newAccessToken, tokenType: .legacy)
        legacyToken =  newAccessToken
        
        return newAccessToken
    }
    
    private enum TokenType {
        case new
        case legacy
    }
}
