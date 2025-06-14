//
//  Configurator.swift
//  Scouter
//
//  Created by Jon Alaniz on 7/28/24.
//

import Foundation

protocol ConfiguratorDelegate: AnyObject {
    func configurationChanged()
}

/// A singleton responsible for managing application configuration and secure secrets.
///
/// `Configurator` handles loading, updating, and saving configuration values to `UserDefaults`,
/// as well as securely storing API credentials or other sensitive data using a `SecretManag
final class Configurator {
    // MARK: - Singleton

    static let shared = Configurator()
    private init() {
        loadConfiguration()
        loadSecret()
    }

    // MARK: - Properties
    private let secretManager = SecretManager.shared
    private let configKey = "com.kami.config"

    weak var delegate: ConfiguratorDelegate?
    private(set) var configuration: Configuration?
    private(set) var secret: Secret?

    // MARK: - Public API
    func updateConfiguration(_ configuration: Configuration) {
        self.configuration = configuration
        saveConfiguration()
        delegate?.configurationChanged()
    }

    func save(secret: Secret) {
        do {
            try secretManager.save(secret)
        } catch {
            print("Unable to save secrets")
        }
    }

    func deleteSecret() {
        do {
            try secretManager.deleteSecret()
        } catch {
            print("Unable to delete key")
        }
    }

    // MARK: - Configuration (Persistence)

    private func loadConfiguration() {
        do {
            guard
                let data = UserDefaults.standard.data(
                    forKey: configKey
                )
            else {
                configuration = Configuration.defaults
                return
            }

            let configuration = try PropertyListDecoder().decode(
                Configuration.self,
                from: data
            )
            self.configuration = configuration
        } catch  {
            // TODO: This will go to Configurator Error
            print(error)
        }
    }

    private func saveConfiguration() {
        do {
            UserDefaults.standard.set(
                try PropertyListEncoder().encode(
                    configuration
                ),
                forKey: configKey
            )
        } catch {
            fatalError("Could not encode configuration")
        }
    }

    private func loadSecret() {
        do {
            let secret = try secretManager.loadSecret()
            self.secret = secret
        } catch {
            print("No secrets here")
        }
    }
}
