//
//  UserInfo.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

nonisolated struct UserInfo: Decodable, Sendable {
    let id: UUID
    let isActive: Bool
    let isAdmin: Bool
    let role: String
    let email: String
}
