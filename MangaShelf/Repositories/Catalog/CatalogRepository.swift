//
//  CatalogRepository.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import Foundation

nonisolated protocol CatalogRepository: Sendable {
    func fetchGenres() async throws -> [String]
    func fetchThemes() async throws -> [String]
    func fetchDemographics() async throws -> [Demographic]
    func fetchAuthors() async throws -> [Author]
}

nonisolated final class CatalogRepositoryImpl: CatalogRepository {
    private let network: any NetworkClient
    
    init(network: any NetworkClient) {
        self.network = network
    }
    
    func fetchGenres() async throws -> [String] {
        try await network.send(CatalogEndpoints.fetchGenres(), as: [String].self)
    }
    
    func fetchThemes() async throws -> [String] {
        try await network.send(CatalogEndpoints.fetchThemes(), as: [String].self)
    }
    
    func fetchAuthors() async throws -> [Author] {
        try await network.send(CatalogEndpoints.fetchAuthors(), as: [Author].self)
    }
    
    func fetchDemographics() async throws -> [Demographic] {
        let demographicsArray = try await network.send(CatalogEndpoints.fetchDemographics(), as: [String].self)
        let demographics = demographicsArray.compactMap { Demographic(rawValue: $0) }
        
        return demographics
    }
}
