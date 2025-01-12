//
//  Configurator.swift
//  Scouter
//
//  Created by Jon Alaniz on 7/28/24.
//

import Foundation

struct Configuration: Codable {
    let secret: Secret

    struct Secret: Codable {
        let url: URL
        let key: String
    }
}

protocol ConfiguratorDelegate: AnyObject {
    func configurationChanged()
}

class Configurator {
    static let shared = Configurator()

    weak var delegate: ConfiguratorDelegate?

    private var configuration: Configuration?

    private init() {
        loadConfiguration()
    }

    private func loadConfiguration() {
        do {
            guard let data = UserDefaults.standard.data(forKey: "com.kami.config")
            else { return }

            let configuration = try PropertyListDecoder().decode(Configuration.self, from: data)
            self.configuration = configuration
        } catch  {
            print(error)
        }


    }

    private func saveConfiguration() {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(configuration), forKey: "com.kami.config")
        } catch {
            fatalError("Could not encode configuration")
        }
    }

    func getConfiguration() -> Configuration? {
        return configuration
    }

    func saveConfiguration(_ configuration: Configuration) {
        self.configuration = configuration
        saveConfiguration()
        delegate?.configurationChanged()
    }

    func signOut() {
        UserDefaults.standard.removeObject(forKey: "com.kami.config")
        configuration = nil
    }
}
