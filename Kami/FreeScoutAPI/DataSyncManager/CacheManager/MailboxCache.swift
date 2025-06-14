//
//  MailboxCache.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import Foundation

struct MailboxCache: Codable {
    let mailboxes: [Mailbox]
    let folders: [Int: Folders]
    let users: [User]
    let timestamp: Date
}
