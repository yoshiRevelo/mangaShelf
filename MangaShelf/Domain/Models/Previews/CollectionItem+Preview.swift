//
//  CollectionItem+Preview.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 01/09/26.
//

import Foundation

// Datos de ejemplo para el MockCollectionRepository y para #Preview
// de las pantallas de Colección. Mismos mangas y valores que SampleData,
// para que previews y seed en memoria se vean consistentes.
extension CollectionItem {

    static var preview: [CollectionItem] {
        [
            CollectionItem(
                mangaID: Manga.monster.id,
                cachedTitle: Manga.monster.title,
                totalVolumes: Manga.monster.volumes,
                ownedVolumes: 18,
                readingVolume: 18,
                isComplete: true
            ),
            CollectionItem(
                mangaID: Manga.berserk.id,
                cachedTitle: Manga.berserk.title,
                totalVolumes: Manga.berserk.volumes,
                ownedVolumes: 5,
                readingVolume: 5,
                isComplete: false
            ),
            CollectionItem(
                mangaID: Manga.twentiethCenturyBoys.id,
                cachedTitle: Manga.twentiethCenturyBoys.title,
                totalVolumes: Manga.twentiethCenturyBoys.volumes,
                ownedVolumes: 10,
                readingVolume: 8,
                isComplete: false
            )
        ]
    }
}
