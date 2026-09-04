//
//  AppEnvironment.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import Foundation
import SwiftData

@Observable
final class AppEnvironment {
    let mangaRepository: any MangaRepository
    let collectionRepository: any CollectionRepository
    
    internal init(mangaRepository: any MangaRepository, collectionRepository: any CollectionRepository) {
        self.mangaRepository = mangaRepository
        self.collectionRepository = collectionRepository
    }
    
    static func live() -> AppEnvironment {
        let network = URLSessionNetworkClient()
        let mangaRepository = MangaRepositoryImpl(network: network)
        let container = AppModelContainer.live()
        let collectionRepository = LocalCollectionRepository(container: container)
        return AppEnvironment(mangaRepository: mangaRepository, collectionRepository: collectionRepository)
    }
    
    static func preview(mangas: PaginatedResponse<Manga> = .preview) -> AppEnvironment {
        let mangaRepository = MockMangaRepository()
        let collectionRepository = MockCollectionRepository()
        return AppEnvironment(mangaRepository: mangaRepository, collectionRepository: collectionRepository)
    }
    
    static func failPreview() -> AppEnvironment {
        let mangaRepository = MockMangaRepository(shouldFail: true, delay: .microseconds(100))
        let collectionRepository = MockCollectionRepository(shouldFail: true, delay: .milliseconds(100))
        return AppEnvironment(mangaRepository: mangaRepository, collectionRepository: collectionRepository)
    }
}
