//
//  AppEnvironment.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class AppEnvironment {
    let mangaRepository: any MangaRepository
    let collectionRepository: any CollectionRepository
    let catalogRepository: any CatalogRepository
    let sessionManager: SessionManager
    let sessionStore: SessionStore
    
    internal init(mangaRepository: any MangaRepository, collectionRepository: any CollectionRepository, catalogRepository: any CatalogRepository, sessionManager: SessionManager, sessionStore: SessionStore) {
        self.mangaRepository = mangaRepository
        self.collectionRepository = collectionRepository
        self.catalogRepository = catalogRepository
        self.sessionManager = sessionManager
        self.sessionStore = sessionStore
    }
    
    static func live() -> AppEnvironment {
        let authNetwork = URLSessionNetworkClient()
        let authRepository = AuthRepositoryImpl(network: authNetwork)
        let sessionManager = SessionManager(keychain: KeychainStore(), authRepository: authRepository)
        let sessionStore = SessionStore(sessionManager: sessionManager)
        
        let network = URLSessionNetworkClient(tokenProvider: sessionManager)
        let mangaRepository = MangaRepositoryImpl(network: network)
//        let container = AppModelContainer.live()
        let collectionNetwork = URLSessionNetworkClient(tokenProvider: LegacyTokenProvider(sessionManager: sessionManager))
        let collectionRepository = RemoteCollectionRepository(network: collectionNetwork)
        
        let catalogRepository = CatalogRepositoryImpl(network: network)
        
        return AppEnvironment(mangaRepository: mangaRepository, collectionRepository: collectionRepository, catalogRepository: catalogRepository, sessionManager: sessionManager, sessionStore: sessionStore)
    }
    
    static func preview(mangas: PaginatedResponse<Manga> = .preview) -> AppEnvironment {
        let sessionManager = SessionManager(keychain: MockKeychainStore(), authRepository: MockAuthRepository())
        let sessionStore = SessionStore(sessionManager: sessionManager)
        
        return AppEnvironment(
            mangaRepository: MockMangaRepository(),
            collectionRepository: MockCollectionRepository(),
            catalogRepository: MockCatalogRepository(),
            sessionManager: sessionManager,
            sessionStore: sessionStore
        )
    }
    
    static func failPreview() -> AppEnvironment {
        let sessionManager = SessionManager(keychain: MockKeychainStore(), authRepository: MockAuthRepository(shouldFail: true))
        let sessionStore = SessionStore(sessionManager: sessionManager)
        
        return AppEnvironment(
            mangaRepository: MockMangaRepository(shouldFail: true, delay: .microseconds(100)),
            collectionRepository: MockCollectionRepository(shouldFail: true, delay: .milliseconds(100)),
            catalogRepository: MockCatalogRepository(shouldFail: true, delay: .milliseconds(100)),
            sessionManager: sessionManager,
            sessionStore: sessionStore
        )
    }
}
