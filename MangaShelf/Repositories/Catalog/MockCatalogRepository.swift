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
    var authors: [Author]
    var shouldFail: Bool
    var delay: Duration
    
    init(genres: [String] = String.genresPreview, themes: [String] = String.themesPreview, demographics: [Demographic] = Demographic.preview, authors: [Author] = Author.preview , shouldFail: Bool = false, delay: Duration = .zero)  {
        self.genres = genres
        self.themes = themes
        self.demographics = demographics
        self.authors = authors
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
    
    func fetchAuthors() async throws -> [Author] {
        try await simulateWork()
        return await authors
    }

    private func simulateWork() async throws {
        if delay != .zero { try? await Task.sleep(for: delay) }
        if shouldFail { throw APIError.offline }
    }
}
