//
//  CollectionEndpoints.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 09/09/26.
//

import Foundation

nonisolated enum CollectionEndpoints {
    static func fetchAll() -> Endpoint {
        Endpoint(path: "collection/manga", requiresAuth: true)
    }
    
    static func fetchItem(mangaID: Int) -> Endpoint {
        Endpoint(path: "collection/manga/\(mangaID)", requiresAuth: true)
    }
    
    static func upsert(mangaID: Int, completeCollection: Bool, volumesOwned: [Int], readingVolume: Int?) throws -> Endpoint {
        struct MyCollection: Encodable {
            let manga: Int
            let completeCollection: Bool
            let volumesOwned: [Int]
            let readingVolume: Int?
        }
        
        let body = try Endpoint.jsonBody(MyCollection(manga: mangaID, completeCollection: completeCollection, volumesOwned: volumesOwned, readingVolume: readingVolume))
        
        return Endpoint(
            path: "collection/manga",
            method: .post,
            body: body,
            requiresAuth: true
        )
    }
    
    static func delete(mangaID: Int) -> Endpoint {
        Endpoint(path: "collection/manga/\(mangaID)", method: .delete,  requiresAuth: true)
    }
}
