//
//  Enums.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import Foundation

enum FilterCategory: Identifiable {
    case genre
    case themes
    case demographic
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .genre: "Genre"
        case .themes: "Theme"
        case .demographic: "Demographic"
        }
    }
}
