//
//  Author.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated struct Author: Decodable, Identifiable, Hashable, Sendable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: String
    
    var authorInformation: String {
        "\(firstName) \(lastName) · \(role)"
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
