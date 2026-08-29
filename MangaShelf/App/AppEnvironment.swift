//
//  AppEnvironment.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import Foundation

@Observable
final class AppEnvironment {
    let mangaRepository: any MangaRepository
    
    init(mangaRepository: any MangaRepository) {
        self.mangaRepository = mangaRepository
    }
    
    static func live() -> AppEnvironment {
        let network = URLSessionNetworkClient()
        let mangaRepository = MangaRepositoryImpl(network: network)
        return AppEnvironment(mangaRepository: mangaRepository)
    }
    
    static func preview(mangas: PaginatedResponse<Manga> = .preview) -> AppEnvironment {
        let mangaRepository = MockMangaRepository()
        return AppEnvironment(mangaRepository: mangaRepository)
    }
    
    static func failPreview() -> AppEnvironment {
        let mangaRepository = MockMangaRepository(shouldFail: true)
        return AppEnvironment(mangaRepository: mangaRepository)
    }
}
