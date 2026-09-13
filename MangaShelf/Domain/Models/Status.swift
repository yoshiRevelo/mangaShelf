//
//  Status.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 30/08/26.
//

import Foundation
import SwiftUI

nonisolated enum Status: String, CaseIterable, Sendable, Identifiable {
    case publishing = "currently_publishing"
    case finished = "finished"
    case other
    
    var id: String { rawValue }
}

extension Status: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = Status(rawValue: raw) ?? .other
    }
}

extension Status {
    var title: String {
        switch self {
        case .publishing: String(localized: "In Progress")
        case .finished: String(localized: "Finished")
        case .other: String(localized: "No info")
        }
    }
    
    var color: Color {
        switch self {
        case .publishing: .warning
        case .finished: .success
        case .other: .secondary
        }
    }
}
