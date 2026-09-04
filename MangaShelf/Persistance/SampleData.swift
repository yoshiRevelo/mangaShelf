//
//  SampleData.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 31/08/26.
//

import Foundation
import SwiftData

enum SampleData {

    static func seed(into context: ModelContext) {
        let monster = CollectionItem(
            mangaID: Manga.monster.id,
            cachedTitle: Manga.monster.title,
            totalVolumes: Manga.monster.volumes,
            ownedVolumes: 18,
            readingVolume: 18,
            isComplete: true
        )

        let berserk = CollectionItem(
            mangaID: Manga.berserk.id,
            cachedTitle: Manga.berserk.title,
            totalVolumes: Manga.berserk.volumes,
            ownedVolumes: 5,
            readingVolume: 5,
            isComplete: false
        )

        let twentiethCenturyBoys = CollectionItem(
            mangaID: Manga.twentiethCenturyBoys.id,
            cachedTitle: Manga.twentiethCenturyBoys.title,
            totalVolumes: Manga.twentiethCenturyBoys.volumes,
            ownedVolumes: 10,
            readingVolume: 8,
            isComplete: false
        )

        [monster, berserk, twentiethCenturyBoys].forEach(context.insert)

        try? context.save()
    }
}
