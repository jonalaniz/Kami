//
//  Endpoint.swift
//  Scouter
//
//  Created by Jon Alaniz on 6/27/24.
//

import Foundation

// swiftlint:disable identifier_name
enum Endpoint {

    /// Fetch a specific conversation by its ID.
    ///
    /// - Parameter id: The unique identifier of the conversation.
    case conversation(Int)

    /// Fetch a paginated list of conversations.
    case conversations

    /// Fetch all folders associated with a given mailbox.
    ///
    /// - Parameter id: The unique identifier of the mailbox.
    case folders(Int)

    /// Fetch all available mailboxes.
    case mailboxes

    /// Fetch all users in the system.
    case users

    /// The path component of the URL corresponding to the API endpoint.
    var path: String {
        var endpoint: String

        switch self {
        case .conversation(let id): endpoint = "api/conversations/\(id)"
        case .conversations: endpoint = "/api/conversations"
        case .folders(let id): endpoint = "/api/mailboxes/\(id)/folders"
        case .mailboxes: endpoint = "/api/mailboxes"
        case .users: endpoint = "/api/users"
        }

        return endpoint
    }
}
