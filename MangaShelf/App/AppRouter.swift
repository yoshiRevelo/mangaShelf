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
    var toast: ToastMessage?
    
    var listPath: [MangaRoute] = []
    
    var collectionDidChange: Int = 0
    var widgetMangaID: Int?
    
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
    case account
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .list: String(localized: "Mangas")
        case .collection: String(localized: "My collection")
        case .search: String(localized: "Search")
        case .account: String(localized: "Account")
        }
    }
    
    var symbol: String {
        switch self {
        case .list: "list.bullet"
        case .collection: "bookmark"
        case .search: "magnifyingglass"
        case .account: "person.crop.circle"
        }
    }
}

nonisolated enum MangaRoute: Hashable {
    case detail(Manga)
}
