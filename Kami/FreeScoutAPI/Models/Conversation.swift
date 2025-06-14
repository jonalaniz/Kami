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
    let type: String
    let folderID: Int
    let status, state, subject, preview: String
    let mailboxID: Int
    let assignee, createdBy: User?
    let createdAt: String
    let updatedAt: String?
    let closedBy: Int?
    let closedByUser: User?
    let closedAt: String?
    let userUpdatedAt: String?
    let customerWaitingSince: TimeFrame
    let source: Source
    let cc, bcc: CCType
    let customer: User
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

struct CustomField: Codable {
    let id: Int
    let name, value, text: String
}

struct EmbeddedThreads: Codable {
    let threads: [Thread]
}

struct Thread: Codable {
    let id: Int
    let type, status, state: String
    let action: Action
    let body: String?
    let source: Source
    let customer, createdBy: User?
    let assignedTo: User?
    let to: [String]
    let cc, bcc: CCType
    let createdAt: String
    let openedAt: String?
    let embedded: ThreadEmbedded

    enum CodingKeys: String, CodingKey {
        case id, type, status, state, action, body, source, customer
        case createdBy, assignedTo, to, cc, bcc, createdAt, openedAt
        case embedded = "_embedded"
    }
}

struct Action: Codable {
    let type, text: String
//    let associatedEntities: [Any]
}

struct ThreadEmbedded: Codable {
    let attachments: [Attachment]
}

struct Attachment: Codable {
    let id: Int
    let fileName: String
    let fileURL: String
    let mimeType: String
    let size: Int

    enum CodingKeys: String, CodingKey {
        case id, fileName
        case fileURL = "fileUrl"
        case mimeType, size
    }
}
