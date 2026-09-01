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
        case .publishing: "In Progress"
        case .finished: "Finished"
        case .other: "No info"
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
