//
//  MangasListViewModel.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 27/08/26.
//

import Foundation

// TODO: si el error ocurre durante un .loadMore, conservar los mangas previos
// en vez de perderlos (ej. case error(String, previousItems: [Manga] = []))

enum ListState<T> {
    case idle
    case loading
    case loaded(T)
    case loadMore(T)
    case error(String)
}

extension ListState: Equatable where T: Equatable {}

extension ListState {
    var isLoading: Bool {
        if case .loading = self { return true }
        if case .loadMore = self { return true }
        return false
    }
    
    var loaded: T? {
        if case .loaded(let value) = self { return value }
        if case .loadMore(let value) = self { return value }
        
        return nil
    }
}

@Observable
@MainActor
final class MangasListViewModel {
    private let repository: any MangaRepository
    private let catalogRepository: any CatalogRepository
    private var metadata: Metadata?
    private(set) var listState: ListState<[Manga]> = .idle
    private(set) var mode: MangaBrowseMode = .all
    
    private let per = 14
    
    //Catalog
    private(set) var genres: [String] = []
    private(set) var themes: [String] = []
    private(set) var demographics: [Demographic] = []
    private(set) var catalogErrorMessage: String?
    private var isCatalogLoaded = false
    
    private var hasMorePages: Bool {
        guard let metadata else { return true}
        
        return mangas.count < metadata.total
    }
    
    var mangas: [Manga] {
        switch listState {
        case .loaded(let items), .loadMore(let items):
            items
        case .idle, .loading, .error:
            []
        }
    }
    
    init(repository: any MangaRepository, catalogRepository: any CatalogRepository) {
        self.repository = repository
        self.catalogRepository = catalogRepository
    }
    
    func loadMangas() async {
        guard !listState.isLoading else { return }
        if metadata != nil, !hasMorePages { return }
        
        let previousMangas = mangas
        listState = previousMangas.isEmpty ? .loading : .loadMore(previousMangas)
        
        let page = (metadata?.page ?? 0) + 1
        let query = MangaListQuery(page: page, per: per, mode: mode)
        
        do {
            let result = try await repository.fetchMangas(query: query)
            metadata =  result.metadata
            listState = .loaded(previousMangas + result.items)
        } catch let error as APIError {
            listState = .error(error.errorDescription ?? "Undefined error")
        } catch {
            listState = .error(error.localizedDescription)
        }
    }
    
    func selectMode(_ newMode: MangaBrowseMode) async {
        if mode != newMode {
            self.mode = newMode
            metadata = nil
            listState = .idle
            await loadMangas()
        }
    }
    
    func loadCatalogIfNeeded() async {
        guard !isCatalogLoaded else { return }
        
        do {
            async let genresResult = catalogRepository.fetchGenres()
            async let themesResult = catalogRepository.fetchThemes()
            async let demographicsResult = catalogRepository.fetchDemographics()
            
            let (fetchedGenres, fetchedThemes, fetchedDemographics) = try await (genresResult, themesResult, demographicsResult)
            
            genres = fetchedGenres
            themes = fetchedThemes
            demographics = fetchedDemographics
            isCatalogLoaded = true
        } catch let error as APIError {
            catalogErrorMessage = error.errorDescription ?? "Undefined error"
        } catch {
            catalogErrorMessage = error.localizedDescription
        }
    }
}
