//
//  FreeScoutService.swift
//  Scouter
//
//  Created by Jon Alaniz on 7/21/24.
//

import Foundation

// swiftlint:disable identifier_name
/// A network service responsible for interfacing with the FreeScout API.
final class FreeScoutService {
    // MARK: - Singleton

    static let shared = FreeScoutService()
    private init() {}

    // MARK: - Properties

    private let apiManager = APIManager.shared

    // MARK: - Requests

    func fetchConversations(using secret: Secret) async throws -> ConversationContainer {
        var urlWithEndpoint = secret.url.appendingPathComponentSafely(
            Endpoint.conversations.path
        )
        urlWithEndpoint.append(
            queryItems: [URLQueryItem(name: "pageSize", value: "200")]
        )
        return try await apiManager.request(
            url: urlWithEndpoint,
            httpMethod: .get,
            body: nil,
            headers: defaultHeaders(withKey: secret.key)
        )
    }

    func fetchFolders(for mailbox: Int, using secret: Secret) async throws -> Folders {
        return try await get(endpoint: .folders(mailbox), secret: secret)
    }

    func fetchMailboxes(using secret: Secret) async throws -> MailboxContainer {
        return try await get(endpoint: .mailboxes, secret: secret)
    }

    func fetchUsers(using secret: Secret) async throws -> UsersContainer {
        return try await get(endpoint: .users, secret: secret)
    }

    func fetchConversation(
        _ id: Int,
        using secret: Secret
    ) async throws -> Conversation {
        return try await get(endpoint: .conversation(id), secret: secret)
    }

    // MARK: - Helper Functions

    private func defaultHeaders(withKey key: String) -> [String: String] {
        let headers: [String: String] = [
            HeaderKeyValue.apiKey.rawValue: key,
            HeaderKeyValue.accept.rawValue: HeaderKeyValue.applicationJSON.rawValue,
            HeaderKeyValue.contentType.rawValue: HeaderKeyValue.jsonCharset.rawValue
        ]
        return headers
    }

    private func makeURL(for endpoint: Endpoint, secret: Secret) -> URL {
        return secret.url.appendingPathComponentSafely(endpoint.path)
    }

    private func get<T: Codable>(
        endpoint: Endpoint,
        secret: Secret
    ) async throws -> T {
        let url = makeURL(for: endpoint, secret: secret)
        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: defaultHeaders(withKey: secret.key)
        )
    }
}
