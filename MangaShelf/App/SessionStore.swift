//
//  SessionStore.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//

import Foundation

@Observable
@MainActor
final class SessionStore {
    private(set) var currentUser: UserInfo?
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    var isAuthenticated: Bool { currentUser != nil }
    
    func restore() async {
        guard await sessionManager.hasStoredSession else { return }
        currentUser = try? await sessionManager.currentUser()
    }
    
    func signIn(email: String, password: String) async throws {
        try await sessionManager.login(email: email, password: password)
        currentUser = try await sessionManager.currentUser()
    }
    
    func register(email: String, password: String) async throws {
        try await sessionManager.register(email: email, password: password)
    }
    
    func signOut() async {
        await sessionManager.logout()
        currentUser = nil
        ReadingSnapshotStore.clear()
    }
}
