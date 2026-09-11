//
//  LegacyTokenProvider.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 10/09/26.
//

import Foundation

struct LegacyTokenProvider: AuthTokenProviding {
    let sessionManager: SessionManager
    func accessToken() async throws -> String? {
        try await sessionManager.legacyAccessToken()
    }
}
