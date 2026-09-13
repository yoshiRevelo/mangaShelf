//
//  Enums.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import Foundation

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

enum FilterCategory: Identifiable {
    case genre
    case themes
    case demographic
    case authors
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .genre: String(localized: "Genre")
        case .themes: String(localized: "Theme")
        case .demographic: String(localized: "Demographic")
        case .authors: String(localized: "Author")
        }
    }
}
