//
//  AppRouter.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import Foundation

@Observable
final class AppRouter {
    var selectedTab: AppTab = .list
    
    var listPath: [MangaRoute] = []
    
    func openDetailFromList(_ manga: Manga) {
        selectedTab = .list
        
        if listPath.last != .detail(manga) {
            listPath.append(.detail(manga))
        }
    }
    
}

nonisolated enum AppTab: String, CaseIterable, Identifiable {
    case list
    case collection
    case search
    case settings
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .list: "Mangas"
        case .collection: "Mi colección"
        case .search: "Buscar"
        case .settings: "Ajustes"
        }
    }
    
    var symbol: String {
        switch self {
        case .list: "list.bullet"
        case .collection: "bookmark"
        case .search: "magnifyingglass"
        case .settings: "gear"
        }
    }
}

nonisolated enum MangaRoute: Hashable {
    case detail(Manga)
}
