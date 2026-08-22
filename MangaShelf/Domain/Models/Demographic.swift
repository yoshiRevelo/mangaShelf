//
//  Demographic.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//

import Foundation

nonisolated enum Demographic: String, CaseIterable, Sendable {
    case shounen = "Shounen"
    case shoujo = "Shoujo"
    case seinen = "Seinen"
    case kids = "Kids"
    case josei = "Josei"
    case other
    
    private enum CodingKeys: String, CodingKey {
        case demographic
    }
}

extension Demographic: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let raw = try container.decode(String.self, forKey: .demographic)
        self = Demographic(rawValue: raw) ?? .other
    }
}
