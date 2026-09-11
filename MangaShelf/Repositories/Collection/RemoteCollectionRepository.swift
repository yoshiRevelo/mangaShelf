//
//  RemoteCollectionRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 09/09/26.
//

import Foundation

@MainActor
final class RemoteCollectionRepository: CollectionRepository {
    private let network: any NetworkClient
    
    init(network: any NetworkClient) {
        self.network = network
    }
    
    func loadCollection() async throws -> [CollectionItem] {
        let dto = try await network.send(CollectionEndpoints.fetchAll(), as: [RemoteCollectionItemDTO].self)
        return dto.map {
            CollectionItem(
                mangaID: $0.manga.id,
                cachedTitle: $0.manga.title,
                totalVolumes: $0.manga.volumes,
                ownedVolumes: $0.volumesOwned.count,
                readingVolume: $0.readingVolume,
                isComplete: $0.completeCollection
            )
        }
    }
    
    func fetchManga(mangaID: Int) async throws -> CollectionItem? {
        let dto = try await network.send(CollectionEndpoints.fetchItem(mangaID: mangaID), as: RemoteCollectionItemDTO.self)
        
        return CollectionItem(
            mangaID: dto.manga.id,
            cachedTitle: dto.manga.title,
            totalVolumes: dto.manga.volumes,
            ownedVolumes: dto.volumesOwned.count,
            readingVolume: dto.readingVolume,
            isComplete: dto.completeCollection
        )
    }
    
    func upsert(_ manga: CollectionItem) async throws {
        try await network.send(CollectionEndpoints.upsert(mangaID: manga.mangaID, completeCollection: manga.isComplete, volumesOwned: manga.ownedVolumes > 0 ? Array(1...manga.ownedVolumes) : [], readingVolume: manga.readingVolume))
    }
    
    func delete(_ manga: CollectionItem) async throws {
        try await network.send(CollectionEndpoints.delete(mangaID: manga.mangaID))
    }
}
