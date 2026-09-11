//
//  RemoteCollectionItemDTO.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 09/09/26.
//

import Foundation

nonisolated struct RemoteCollectionItemDTO: Decodable, Sendable {
    let id: UUID
    let manga: Manga
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}
