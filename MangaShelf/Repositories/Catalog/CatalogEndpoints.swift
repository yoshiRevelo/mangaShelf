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
    
    static func fetchAuthors(page: Int, per: Int) -> Endpoint {
        let endPoint: Endpoint
        
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per", value: String(per))
        ]
        
        endPoint = Endpoint(path: "list/authorsPaged", queryItems: queryItems)
        
        return endPoint
    }
}
