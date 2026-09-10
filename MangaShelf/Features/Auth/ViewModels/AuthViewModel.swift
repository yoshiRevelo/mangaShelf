//
//  AuthViewModel.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//

import Foundation

enum AuthMode {
    case login
    case register
}

@Observable
@MainActor
final class AuthViewModel {
    var mode: AuthMode = .login
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    var isLoading = false
    
    var errorMessage = ""
    
    func toggleMode() {
        mode = mode == .login ? .register : .login
        errorMessage = ""
        reset()
    }
    
    func submit(using session: SessionStore) async -> Bool {
        errorMessage = ""
        
        guard Validators.isValidEmail(email) else {
            errorMessage = "Enter a valid email"
            return false }
        guard Validators.isValidPassword(password) else {
            errorMessage = "Password must be at least 8 characters"
            return false
        }
        
        if mode == .register && password != confirmPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            switch mode {
            case .login:
                try await session.signIn(email: email, password: password)
                reset()
                return true
            case .register:
                try await session.register(email: email, password: password)
                return true
            }
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }
    
    func reset() {
        email = ""
        password = ""
        confirmPassword = ""
    }
}
