//
//  AuthToken.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

nonisolated struct AuthToken: Codable, Sendable {
    let token: String
    let expirationDate: Date
    
    var isExpired: Bool {
        Date() >= expirationDate
    }
    
    init(dto: AuthTokenDTO) {
        self.token = dto.token
        self.expirationDate = Date() + TimeInterval(dto.expiresIn)
    }
}
