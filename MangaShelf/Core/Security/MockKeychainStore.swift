//
//  MockKeychainStore.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

final class MockKeychainStore: KeychainStoring, @unchecked Sendable {
    private var storage: [String: Data] = [:]

    func save(_ data: Data, for key: String) throws { storage[key] = data }
    func read(for key: String) throws -> Data? { storage[key] }
    func delete(for key: String) throws { storage[key] = nil }
}


