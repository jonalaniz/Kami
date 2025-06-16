//
//  Conversation.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import Foundation

// swiftlint:disable identifier_name
struct Conversation: Codable {
    let id, number, threadsCount: Int
    let type: ConversationType
    let folderID: Int
    let status: ConversationStatus
    let state: ConversationState
    let subject, preview: String
    let mailboxID: Int
    let assignee: Assignee?
    let createdBy: ConversationUser?
    let createdAt: String
    let updatedAt: String?
    let closedBy: Int?
    let closedByUser: ConversationUser?
    let closedAt: String?
    let userUpdatedAt: String?
    let customerWaitingSince: TimeFrame
    let source: Source
    let cc, bcc: CCType
    let customer: ConversationUser
    let embedded: EmbeddedThreads
    let customFields: [CustomField]?

    enum CodingKeys: String, CodingKey {
        case id, number, threadsCount, type
        case folderID = "folderId"
        case status, state, subject, preview
        case mailboxID = "mailboxId"
        case assignee, createdBy, createdAt, updatedAt
        case closedBy, closedByUser, closedAt, userUpdatedAt
        case customerWaitingSince, source, cc, bcc, customer
        case embedded = "_embedded"
        case customFields
    }
}

struct Assignee: Codable {
    let id: Int
    let type: String?
    let firstName: String?
    let lastName: String?
    let email: String

    var displayName: String {
        let fullName = [firstName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return fullName.isEmpty ? email : fullName
    }
}

struct ConversationUser: Codable {
    let id: Int
    let type: String?
    let firstName: String?
    let lastName: String?
    let photoUrl: String?
    let email: String

    var displayName: String {
        let fullName = [firstName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return fullName.isEmpty ? email : fullName
    }
}
