//
//  MockCollectionRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 01/09/26.
//

import Foundation
import SwiftData

final class MockCollectionRepository: CollectionRepository {
    var items: [CollectionItem]
    var shouldFail: Bool
    var delay: Duration
    
    init(items: [CollectionItem] = CollectionItem.preview, shouldFail: Bool = false, delay: Duration = .zero) {
        self.items = items
        self.shouldFail = shouldFail
        self.delay = delay
    }
    
    func loadCollection() async throws -> [CollectionItem] {
        try await simulateWork()
        return items.sorted { $0.mangaID < $1.mangaID }
    }
    
    func fetchManga(mangaID: Int) async throws -> CollectionItem? {
        try await simulateWork()
        return items.first { $0.mangaID == mangaID }
    }
    
    func upsert(_ manga: CollectionItem) async throws {
        try await simulateWork()
        let indice = items.firstIndex { $0.mangaID == manga.mangaID }
        
        if let indice {
            items[indice] = manga
        } else {
            items.append(manga)
        }
    }
    
    func delete(_ manga: CollectionItem) async throws {
        try await simulateWork()
        items.removeAll { $0.mangaID == manga.mangaID }
    }
    
    private func simulateWork() async throws {
        if delay != .zero { try? await Task.sleep(for: delay) }
        if shouldFail { throw MemoryError.mockError}
    }
    
    nonisolated enum MemoryError: LocalizedError, Equatable, Sendable {
        case mockError
        
        var errorDescription: String? {
            switch self {
            case .mockError: "Swift data is unavailable. Try again later."
            }
        }
    }
}

