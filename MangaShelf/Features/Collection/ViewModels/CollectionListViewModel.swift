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
        case .all: String(localized: "All")
        case .finished: String(localized: "Finished")
        case .pending: String(localized: "Pending")
        }
    }
}

extension CollectionItem {
    var isFinishedReading: Bool { ownedVolumes > 0 && readingVolume == ownedVolumes }
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
        
        if let items = listState.loaded {
                listState = .loadMore(items)
            } else {
                listState = .loading
            }
        
        do {
            let items = try await repository.loadCollection()
            listState = .loaded(items)
            ReadingSnapshotStore.save(from: items)
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
    
    func deleteItem(manga: CollectionItem) async {
        do {
            try await repository.delete(manga)
            if var items = listState.loaded {
                items.removeAll { $0.id == manga.id }
                listState = .loaded(items)
                ReadingSnapshotStore.save(from: items)
            }
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
    
    func toggleComplete(manga: CollectionItem) async {
        manga.isComplete.toggle()
        do {
            try await repository.upsert(manga)
            ReadingSnapshotStore.save(from: listState.loaded ?? [])
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
}
