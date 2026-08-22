//
//  MangaListQuery.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated enum MangaBrowseMode: Sendable {
    case all
    case genre(String)
    case theme(String)
    case demographic(Demographic)
    case author(UUID)
}

nonisolated struct MangaListQuery: Sendable {
    var page: Int
    var per: Int = 10
    var mode: MangaBrowseMode = .all
}
