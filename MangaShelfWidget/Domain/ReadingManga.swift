//
//  ReadingManga.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 12/09/26.
//

import Foundation

struct ReadingManga: Codable, Identifiable, Sendable {
    let mangaID: Int
    let title: String
    let readingVolume: Int
    let ownedVolumes: Int
    
    var id: Int { mangaID }
}
