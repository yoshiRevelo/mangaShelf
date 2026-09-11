//
//  KeychainStore.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation
import Security

nonisolated enum KeychainError: Error, Equatable {
    case unexpectedStatus(OSStatus)
    case dataConversionFailed
}

nonisolated protocol KeychainStoring: Sendable {
    func save(_ data: Data, for key: String) throws
    func read(for key: String) throws -> Data?
    func delete(for key: String) throws
}

nonisolated extension KeychainStoring {
    func saveString(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else { throw KeychainError.dataConversionFailed }
        try save(data, for: key)
    }
    
    func readString(for key: String) throws -> String? {
        guard let data = try read(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

nonisolated struct KeychainStore: KeychainStoring {
    let service: String
    
    init(service: String = "com.mx.MangaShelf") {
        self.service = service
    }
    
    func save(_ data: Data, for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        
        let attributesToUpdate: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        switch status {
        case errSecSuccess:
            return
            
        case errSecItemNotFound:
            var newItem = query
            newItem[kSecValueData as String] = data
            newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            let addStatus = SecItemAdd(newItem as CFDictionary, nil)
            guard addStatus == errSecSuccess else { throw KeychainError.unexpectedStatus(addStatus) }
            
        default:
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func read(for key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}

nonisolated enum KeychainKey {
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    static let legacyToken = "legacyToken"
}
