//
//  CatalogEndpoints.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import Foundation

nonisolated enum CatalogEndpoints {
    static func fetchGenres() -> Endpoint {
        return Endpoint(path: "list/genres")
    }
    
    static func fetchThemes() -> Endpoint {
        return Endpoint(path: "list/themes")
    }
    
    static func fetchDemographics() -> Endpoint {
        return Endpoint(path: "list/demographics")
    }
    
    static func fetchAuthors() -> Endpoint {
        return Endpoint(path: "list/authors")
    }
}
