//
//  FreeScoutService.swift
//  Scouter
//
//  Created by Jon Alaniz on 7/21/24.
//

import Foundation

final class FreeScoutService {
    static let shared = FreeScoutService()
    
    private let apiManager = APIManager.shared

    private var folders = [Folder]()
    
    private init() {}
    
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
        let urlWithEndpoint = secret.url.appendingPathComponentSafely(
            Endpoint.folders(mailbox).path
        )
        return try await apiManager.request(
            url: urlWithEndpoint,
            httpMethod: .get,
            body: nil,
            headers: defaultHeaders(withKey: secret.key)
        )
    }
    
    func fetchMailboxes(using secret: Secret) async throws -> MailboxContainer {
        let urlWithEndpoint = secret.url.appendingPathComponentSafely(
            Endpoint.mailbox.path
        )
        return try await apiManager.request(
            url: urlWithEndpoint,
            httpMethod: .get,
            body: nil,
            headers: defaultHeaders(withKey: secret.key)
        )
    }

    func fetchUsers(using secret: Secret) async throws -> Users {
        let urlWithEndpoint = secret.url.appendingPathComponentSafely(
            Endpoint.users.path
        )
        return try await apiManager.request(url: urlWithEndpoint,
                                            httpMethod: .get,
                                            body: nil,
                                            headers: defaultHeaders(withKey: secret.key))
    }

    func fetchConversation(_ id: Int, using secret: Secret) async throws -> Conversation {
        let urlWithEndpoint = secret.url.appendingPathComponentSafely(
            Endpoint.conversation(id).path
        )
        return try await apiManager.request(
            url: urlWithEndpoint,
            httpMethod: .get,
            body: nil,
            headers: defaultHeaders(withKey: secret.key)
        )
    }

    func set(_ folders: Folders) {
        self.folders = folders.container.folders.sorted(
            by: { $0.id < $1.id }
        )
    }

    func mainFolders() -> [Folder] {
        return folders.filter { $0.userId == nil }
    }
    
    private func defaultHeaders(withKey key: String) -> [String: String] {
        let headers: [String: String] = [
            HeaderKeyValue.apiKey.rawValue: key,
            HeaderKeyValue.accept.rawValue: HeaderKeyValue.applicationJSON.rawValue,
            HeaderKeyValue.contentType.rawValue: HeaderKeyValue.jsonCharset.rawValue
        ]
        
        return headers
    }
}
