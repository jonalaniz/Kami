//
//  KeychainHelper.swift
//  Ionic
//
//  Created by Jon Alaniz on 4/1/25.
//

import Foundation
import Security

enum KeychainError: Error {
    /// Item does not exist in Keychain.
    case itemNotFound

    /// Attempted to save an existing item. Use update instead.
    case duplicateItem

    /// The retrieved item is in a format other than `Data`.
    case invalidItemFormat

    /// An unexpected OSStatus error occurred.
    case unexpectedStatus(OSStatus)
}

/**
 A helper class for securely storing and retrieving data from the iOS/macOS Keychain.

 ## Keychain Attributes Used:
 - `kSecAttrService`: A string to identify a set of Keychain items (e.g., "com.jonalaniz.ionic").
 - `kSecAttrAccount`: A string to identify a specific Keychain item within a service (e.g., "jon@alaniz.tech").
 - `kSecClass`: The type of secure data stored in the Keychain, such as `kSecClassGenericPassword`.
 - `kSecMatchLimitOne`: Ensures only one matching item is returned when retrieving data.
 - `kSecReturnData`: Specifies that the retrieved item should be returned as `Data`.
 */
class KeychainHelper {
    let service: String

    init(service: String) {
        self.service = service
    }

    func set<T: Codable>(_ object: T, for account: String) throws {
        let data = try JSONEncoder().encode(object)
        try set(data, account: account)
    }

    func get<T: Codable>(_ type: T.Type, for account: String) throws -> T {
        let data = try retrieveData(account: account)
        return try JSONDecoder().decode(type, from: data)
    }

    /// Sets or updates data in the Keychain.
    /// - Parameters:
    ///   - data: The data to store securely.
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.unexpectedStatus` if an error occurs.
    private func set(_ data: Data, account: String) throws {
        do {
            try store(data: data, account: account)
        } catch KeychainError.duplicateItem {
            try update(data: data, account: account)
        }
    }

    /// Stores data in the Keychain.
    /// - Parameters:
    ///   - data: The data to store securely.
    ///   - service: The Keychain service identifier.
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.duplicateItem` if the item already exists, or
    /// `KeychainError.unexpectedStatus` if an error occurs.
    private func store(data: Data, account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem { throw KeychainError.duplicateItem }

        guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
    }

    /// Retrieves data from the Keychain.
    /// - Parameters:
    ///   - service: The Keychain service identifier.
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.itemNotFound` if no matching item is found,
    ///           `KeychainError.invalidItemFormat` if the stored data is not `Data`.
    /// - Returns: The retrieved data.
    private func retrieveData(account: String) throws -> Data {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }

        guard let data = itemCopy as? Data else { throw KeychainError.invalidItemFormat }

        return data
    }

    /// Updates data in the Keychain.
    /// - Parameters:
    ///   - data: The data to store securely.
    ///   - service: The Keychain service identifier.
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.itemNotFound` if the item does not exist, or
    /// `KeychainError.unexpectedStatus` if an error occurs.
    private func update(data: Data, account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]

        let attributes: [String: AnyObject] = [
            kSecValueData as String: data as AnyObject
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }

        guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
    }

    /// Deletes data in the Keychain
    /// - Parameters:
    ///   - service: The Keychain service identifier
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.unexpectedStatus` if an error occurs.
    func delete(account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
