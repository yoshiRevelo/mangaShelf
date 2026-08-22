//
//  MangaEndpoints.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 22/08/26.
//

import Foundation

nonisolated enum MangaEndpoints {
    static func fetchMangas(query: MangaListQuery) -> Endpoint {
        let endpoint: Endpoint
        let queryItems = [
            URLQueryItem(name: "page", value: String(query.page)),
            URLQueryItem(name: "per", value: String(query.per))
        ]
        
        switch query.mode {
        case .all:
            endpoint = Endpoint(path: "list/mangas", queryItems: queryItems)
        case .genre(let value):
            endpoint = Endpoint(path: "list/mangaByGenre/\(value)", queryItems: queryItems)
        case .theme(let value):
            endpoint = Endpoint(path: "list/mangaByTheme/\(value)", queryItems: queryItems)
        case .demographic(let demographic):
            endpoint = Endpoint(path: "list/mangaByDemographic/\(demographic.rawValue.lowercased())", queryItems: queryItems)
        case .author(let id):
            endpoint = Endpoint(path: "list/mangaByAuthor/\(id.uuidString)", queryItems: queryItems)
        }
        
        return endpoint
    }
}
