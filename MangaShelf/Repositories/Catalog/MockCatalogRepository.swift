//
//  MockCatalogRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import Foundation

@MainActor
final class MockCatalogRepository: CatalogRepository {
    
    var genres: [String]
    var themes: [String]
    var demographics: [Demographic]
    var authorsInfo: PaginatedResponse<Author>
    var shouldFail: Bool
    var delay: Duration
    
    init(genres: [String] = String.genresPreview, themes: [String] = String.themesPreview, demographics: [Demographic] = Demographic.preview, authorsInfo: PaginatedResponse<Author> = PaginatedResponse.preview, shouldFail: Bool = false, delay: Duration = .zero)  {
        self.genres = genres
        self.themes = themes
        self.demographics = demographics
        self.authorsInfo = authorsInfo
        self.shouldFail = shouldFail
        self.delay = delay
    }
    
    func fetchGenres() async throws -> [String] {
        try await simulateWork()
        return await genres
    }
    
    func fetchThemes() async throws -> [String] {
        try await simulateWork()
        return await themes
    }
    
    func fetchDemographics() async throws -> [Demographic] {
        try await simulateWork()
        return await demographics
    }
    
    func fetchAuthors(page: Int, per: Int) async throws -> PaginatedResponse<Author> {
        try await simulateWork()
        return await authorsInfo
    }

    private func simulateWork() async throws {
        if delay != .zero { try? await Task.sleep(for: delay) }
        if shouldFail { throw APIError.offline }
    }
}
