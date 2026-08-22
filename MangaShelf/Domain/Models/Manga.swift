//
//  Manga.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated struct Manga: Identifiable, Decodable, Hashable, Sendable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let synopsis: String?
    let background: String?
    let status: String
    let score: Double?
    let chapters: Int?
    let volumes: Int?
    let startDate: Date?
    let endDate: Date?
    let mainPicture: URL?
    let url: URL?
    let authors: [Author]
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleEnglish
        case titleJapanese
        case synopsis = "sypnosis"
        case background
        case status
        case score
        case chapters
        case volumes
        case startDate
        case endDate
        case mainPicture
        case url
        case authors
        case genres
        case themes
        case demographics
    }
}
