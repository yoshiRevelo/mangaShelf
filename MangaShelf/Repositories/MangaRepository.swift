//
//  MangaRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated protocol MangaRepository: Sendable {
    func fetchMangas(query: MangaListQuery) async throws -> PaginatedResponse<Manga>
}

nonisolated final class MangaRepositoryImpl: MangaRepository {
    private let network: any NetworkClient
    
    init(network: any NetworkClient) {
        self.network = network
    }
    
    func fetchMangas(query: MangaListQuery) async throws -> PaginatedResponse<Manga> {
        try await network.send(MangaEndpoints.fetchMangas(query: query), as: PaginatedResponse<Manga>.self)
    }
}
