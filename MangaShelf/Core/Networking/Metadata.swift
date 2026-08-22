//
//  Metadata.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated struct Metadata: Decodable, Sendable {
    let total: Int
    let page: Int
    let per: Int
}
