//
//  MailboxContainer.swift
//  Scouter
//
//  Created by Jon Alaniz on 6/27/24.
//

import Foundation

// swiftlint:disable identifier_name
struct MailboxContainer: Codable, Equatable {
    let embeddedMailboxes: EmbeddedMailboxes
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embeddedMailboxes = "_embedded"
        case page
    }

    init(embeddedMailboxes: EmbeddedMailboxes, page: Page) {
        self.embeddedMailboxes = embeddedMailboxes
        self.page = page
    }
}

struct EmbeddedMailboxes: Codable, Equatable {
    let mailboxes: [Mailbox]
}

struct Mailbox: Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let updatedAt: String
}
