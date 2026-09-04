//
//  CollectionItemViewModel.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 02/09/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class CollectionItemViewModel {
    
    let repository: CollectionRepository
    var collectionItem: CollectionItem
    var errorMessage: String?
    
    init(collectionItem: CollectionItem, repository: CollectionRepository) {
        self.collectionItem = collectionItem
        self.repository = repository
    }
    
    func upsert(draft: DraftItem) async {
        do {
            collectionItem.ownedVolumes = draft.ownedVolumes
            collectionItem.readingVolume = draft.readingVolume
            collectionItem.isComplete = draft.isComplete
            collectionItem.lastUpdated = .now
            try await repository.upsert(collectionItem)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteItem(draft: DraftItem) async {
        do {
            try await repository.delete(collectionItem)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
