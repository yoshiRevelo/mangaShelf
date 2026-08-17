//
//  APIError.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import Foundation

nonisolated enum APIError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case offline
    case transport(String)
    case invalidResponse
    case unauthorized
    case unexpectedStatus(code: Int, message: String?)
    case decoding(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            String(localized: "The request address is not valid.")
        case .offline:
            String(localized: "No internet connection. Showing saved data.")
        case .transport(let detail):
            String(localized: "Connection problem: \(detail)")
        case .invalidResponse:
            String(localized: "The server response was not valid.")
        case .unauthorized:
            String(localized: "Your session has expired. Please sign in again.")
        case .unexpectedStatus(let code, let message):
            message ?? String(localized: "Unexpected server error (\(code)).")
        case .decoding(let detail):
            String(localized: "Could not read the server data: \(detail)")
        }
    }
}
