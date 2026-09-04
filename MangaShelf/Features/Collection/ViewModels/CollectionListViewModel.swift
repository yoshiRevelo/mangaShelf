//
//  CollectionListViewModel.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 02/09/26.
//

import Foundation
import SwiftData

enum CollectionFilter: String, CaseIterable, Hashable, Identifiable, Equatable {
    case all, finished, pending
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .all: "All"
        case .finished: "Finished"
        case .pending: "Pending"
        }
    }
}

extension CollectionItem {
    var isFinishedReading: Bool { readingVolume == ownedVolumes }
}

@Observable
@MainActor
final class CollectionListViewModel {
    private let repository: any CollectionRepository
    private(set) var listState: ListState<[CollectionItem]> = .idle
    
    var filter: CollectionFilter = .all
    var filteredItems: [CollectionItem] {
        let items = listState.loaded ?? []
        
        switch filter {
        case .all: return items
        case .finished: return items.filter { $0.isFinishedReading }
        case .pending: return items.filter { !$0.isFinishedReading }
        }
    }
    
    init(repository: any CollectionRepository) {
        self.repository = repository
    }
    
    func loadCollection() async {
        guard !listState.isLoading else { return }
        listState = .loading
        do {
            let items = try await repository.loadCollection()
            listState = .loaded(items)
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
    
    func deleteItem(manga: CollectionItem) async {
        do {
            try await repository.delete(manga)
            await loadCollection()
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
    
    func toggleComplete(manga: CollectionItem) async {
        manga.isComplete.toggle()
        do {
            try await repository.upsert(manga)
            await loadCollection()
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
}
