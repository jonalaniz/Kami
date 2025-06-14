//
//  Endpoint.swift
//  Scouter
//
//  Created by Jon Alaniz on 6/27/24.
//

import Foundation

// swiftlint:disable identifier_name
enum Endpoint {
    case conversation(Int)
    case conversations
    case folders(Int)
    case mailbox
    case users

    var path: String {
        var endpoint: String

        switch self {
        case .conversation(let id): endpoint = "api/conversations/\(id)"
        case .conversations: endpoint = "/api/conversations"
        case .folders(let id): endpoint = "/api/mailboxes/\(id)/folders"
        case .mailbox: endpoint = "/api/mailboxes"
        case .users: endpoint = "/api/users"
        }

        return endpoint
    }
}
