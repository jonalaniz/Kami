//
//  CacheManager.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    private init() {}

    private let fileManager = FileManager.default
    private let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0].appendingPathExtension("KamiCache")
    }()

    func save<T: Encodable>(_ object: T, as fileName: String) {
        do {
            let fileURL = cacheDirectory.appendingPathComponent(fileName)
            try createDirectoryIfNeeded()
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
        } catch {
            print("Cache save failed with: \(error.localizedDescription)")
        }
    }

    func load<T: Decodable>(_ type: T.Type, from fileName: String) -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path())
        else { return nil }

        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Cache load failed with: \(error.localizedDescription)")
            return nil
        }
    }

    func delete(_ fileName: String) {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: fileURL)
    }

    private func createDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: cacheDirectory.path(percentEncoded: true)) {
            try fileManager.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true
            )
        }
    }
}
