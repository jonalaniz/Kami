//
//  APIKeyManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/23/25.
//

import Foundation

class SecretManager {
    // MARK: - Singleton
    static let shared = SecretManager()
    private init() {}

    // MARK: - Properties

    private let keychainHelper = KeychainHelper(service: "com.jonalaniz.kami")
    private let account = "Secret"

    func loadSecret() throws -> Secret {
        return try keychainHelper.get(
            Secret.self,
            for: account
        )
    }

    func save(_ secret: Secret) throws {
        try keychainHelper.set(secret, for: account)
    }

    func deleteSecret() throws {
        try keychainHelper.delete(account: account)
    }
}
