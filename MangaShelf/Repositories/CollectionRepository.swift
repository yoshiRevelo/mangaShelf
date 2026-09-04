//
//  CollectionRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 01/09/26.
//

import Foundation
import SwiftData

@MainActor
protocol CollectionRepository {
    func loadCollection() async throws -> [CollectionItem]
    func fetchManga(mangaID: Int) async throws -> CollectionItem?
    func upsert(_ manga: CollectionItem) async throws
    func delete(_ manga: CollectionItem) async throws
}

@MainActor
final class LocalCollectionRepository: CollectionRepository {
    private let container: ModelContainer
    let context: ModelContext
    
    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }
    
    func loadCollection() async throws -> [CollectionItem] {
        let descriptor = FetchDescriptor<CollectionItem>(
            sortBy: [SortDescriptor(\.mangaID)]
        )
        
        return try context.fetch(descriptor)
    }
    
    func fetchManga(mangaID: Int) async throws -> CollectionItem? {
        let predicate = #Predicate<CollectionItem> { $0.mangaID == mangaID }
        let descriptor = FetchDescriptor<CollectionItem>(predicate: predicate)
        
        return try context.fetch(descriptor).first
    }
    
    func upsert(_ manga: CollectionItem) async throws {
        context.insert(manga)
        try context.save()
    }
    
    func delete(_ manga: CollectionItem) async throws {
        context.delete(manga)
        try context.save()
    }
}
