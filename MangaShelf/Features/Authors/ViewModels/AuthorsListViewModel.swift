//
//  AuthorsListViewModel.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import Foundation

@Observable
@MainActor
final class AuthorsListViewModel {
    let repository: any CatalogRepository
    private var metadata: Metadata?
    private(set) var listState: ListState<[Author]> = .idle
    
    private let per = 14
    
    private var hasMorePages: Bool {
        guard let metadata else { return true}
        
        return authors.count < metadata.total
    }
    
    var authors: [Author] {
        switch listState {
        case .loaded(let items), .loadMore(let items):
            items
        case .idle, .loading, .error:
            []
        }
    }
    
    init(catalogRepository: any CatalogRepository) {
        self.repository = catalogRepository
    }
    
    func loadAuthors() async {
        guard !listState.isLoading else { return }
        if metadata != nil, !hasMorePages { return }
        
        let previousAuthors = authors
        listState = previousAuthors.isEmpty ? .loading : .loadMore(previousAuthors)
        
        let page = (metadata?.page ?? 0) + 1
        
        do {
            let result = try await repository.fetchAuthors(page: page, per: per)
            metadata =  result.metadata
            listState = .loaded(previousAuthors + result.items)
        } catch let error as APIError {
            listState = .error(error.errorDescription ?? "Undefined error")
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
}
