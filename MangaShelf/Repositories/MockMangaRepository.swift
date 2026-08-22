//
//  MockMangaRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 22/08/26.
//

import Foundation

@MainActor
final class MockMangaRepository: MangaRepository {
    var items: PaginatedResponse<Manga>
    var shouldFail: Bool
    var delay: Duration
    
    init(items: PaginatedResponse<Manga> = .preview, shouldFail: Bool = false, delay: Duration = .zero)  {
        self.items = items
        self.shouldFail = shouldFail
        self.delay = delay
    }
    
    func fetchMangas(query: MangaListQuery) async throws -> PaginatedResponse<Manga> {
        try await simulateWork()
        return await items
    }
    
    private func simulateWork() async throws {
        if delay != .zero { try? await Task.sleep(for: delay) }
        if shouldFail { throw APIError.offline }
    }
}
