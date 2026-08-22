//
//  Genre.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 21/08/26.
//
import Foundation

nonisolated struct Genre: Decodable, Identifiable, Hashable, Sendable {
    let id: UUID
    let genre: String
}
