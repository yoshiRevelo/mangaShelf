//
//  AuthTokenDTO.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

nonisolated struct AuthTokenDTO: Decodable, Sendable {
    let tokenType: String
    let token: String
    let tokenUse: String
    let expiresIn: Int64
}

nonisolated struct LegacyTokenDTO: Decodable, Sendable {
    let token: String
}
