//
//  MangaCollection.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 31/08/26.
//

import Foundation
import SwiftData

@Model
final class CollectionItem {
    @Attribute(.unique) var mangaID: Int
    var cachedTitle: String
    @Attribute(.externalStorage) var coverImage: Data?
    var totalVolumes: Int?
    var ownedVolumes: Int
    var readingVolume: Int?
    var isComplete: Bool
    var lastUpdated: Date
    
    init(mangaID: Int, cachedTitle: String, coverImage: Data? = nil, totalVolumes: Int? = nil, ownedVolumes: Int = 0, readingVolume: Int? = nil, isComplete: Bool = false, lastUpdated: Date = .now) {
        self.mangaID = mangaID
        self.cachedTitle = cachedTitle
        self.coverImage = coverImage
        self.totalVolumes = totalVolumes
        self.ownedVolumes = ownedVolumes
        self.readingVolume = readingVolume
        self.isComplete = isComplete
        self.lastUpdated = lastUpdated
    }
}
