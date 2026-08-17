//
//  HTTPMethod.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import Foundation

nonisolated enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
