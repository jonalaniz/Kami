//
//  MailboxCache.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import Foundation

struct MailboxCache: Codable {

    /// The array of Mailboxes saved to cache.
    let mailboxes: [Mailbox]

    /// A directory mapping mailbox IDs to  their associated Folders
    let folders: [Int: Folders]

    /// The array of Users rsaved to cache.
    let users: [User]

    /// The date at which the cache was created.
    let timestamp: Date

    /// Returns a `MailboxSyncResult` representation of the cached mailbox data.
    ///
    /// Use this property to hydrate in-memory data from a previously saved `MailboxCache`.
    ///
    /// - Returns: A `MailboxSyncResult` created from the cached mailboxes, folders, and users.
    var syncResult: MailboxSyncResult {
        return MailboxSyncResult(
            mailboxes: self.mailboxes,
            folders: self.folders,
            users: self.users
        )
    }
}
