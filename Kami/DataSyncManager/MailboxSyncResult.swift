//
//  MailboxSyncResult.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import Foundation

/// A data container representing the result of a mailbox synchronization operation.
///
/// This struct bundles together related mailbox data retrieved from the server,
/// including the list of mailboxes, their associated folders, and user metadata.
///
/// Use this model to pass mailbox-related sync results to consumers like
/// view controllers, data sources, or coordinators.
struct MailboxSyncResult {

    /// The array of Mailboxes retrieved during syncronization.
    let mailboxes: [Mailbox]

    /// A directory mapping mailbox IDs to  their associated Folders
    let folders: [Int: Folders]

    /// The array of Users retrieved during synchronization
    let users: [User]

    /// Returns a `MailboxCache` representation of the current sync result.
    ///
    /// This is typically used to persist the current mailbox state to disk.
    /// The returned `MailboxCache` includes a timestamp reflecting when the cache was created.
    ///
    /// - Returns: A `MailboxCache` instance populated with the current mailboxes, folders, and users.
    var cache: MailboxCache {
        return MailboxCache(
            mailboxes: self.mailboxes,
            folders: self.folders,
            users: self.users,
            timestamp: Date()
        )
    }
}
