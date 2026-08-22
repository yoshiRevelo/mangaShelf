//
//  PaginatedResponse.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated struct PaginatedResponse<Item: Decodable & Sendable>: Decodable, Sendable {
    let metadata: Metadata
    let items: [Item]
}


