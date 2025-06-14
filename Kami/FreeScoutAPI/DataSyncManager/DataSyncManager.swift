//
//  DataSyncManager.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import Foundation

/// Preliminary Delegate Protocol
protocol DataSyncManagerDelegate: AnyObject {
    func syncDidStart()
    func syncDidFinish()
    func syncDidFail(with error: Error)
    func mailboxesDidLoad(_ result: MailboxSyncResult)
    func mailboxCacheLoaded(_ result: MailboxSyncResult)
}

class DataSyncManager: NSObject {

    // MARK: - Singleton

    static let shared = DataSyncManager()
    private override init() {}

    // MARK: - Properties

    private let cacheManager = CacheManager.shared
    private let service = FreeScoutService.shared

    weak var delegate: DataSyncManagerDelegate?
    var secret: Secret?

    private var isSyncing = false
    private var mailboxes = [Mailbox]()
    private var mailboxFolders = [Int: Folders]()
    private var users = [User]()

    @MainActor func syncMailboxStructure() {
        guard let secret = secret else { return }
        guard !isSyncing else { return }

        loadMailboxesFromCache()

        isSyncing = true
        delegate?.syncDidStart()

        Task {
            do {
                defer { isSyncing = false }

                // Grab users
                let usersContainer = try await service.fetchUsers(
                    using: secret
                )
                users = usersContainer.embeddedUsers.users

                // Grab the Mailboxes
                let mailboxContainer = try await service.fetchMailboxes(
                    using: secret
                )
                mailboxes = mailboxContainer.embeddedMailboxes.mailboxes

                // Grab the folders in each mailbox
                for mailbox in mailboxes {
                    let folders = try await service.fetchFolders(
                        for: mailbox.id, using: secret
                    )
                    mailboxFolders[mailbox.id] = folders
                }

                let result = MailboxSyncResult(
                    mailboxes: mailboxes,
                    folders: mailboxFolders,
                    users: users
                )

                let cache = MailboxCache(
                    mailboxes: mailboxes,
                    folders: mailboxFolders,
                    users: users,
                    timestamp: Date()
                )

                saveToCache(cache)
                mailboxesDidLoad(result)
            } catch {
                print(error)
            }
        }
    }

    func getFolder(section: Int, row: Int) -> Folder? {
        let mailbox = mailboxes[section]
        return mailboxFolders[mailbox.id]?.container.folders[row]
    }

    private func loadMailboxesFromCache() {
        // Check cache first
        if let cached = cacheManager.load(
            MailboxCache.self,
            from: "mailboxes.json"
        ) {
            mailboxes = cached.mailboxes
            mailboxFolders = cached.folders
            users = cached.users
            mailboxCacheUpdated(
                MailboxSyncResult(
                    mailboxes: mailboxes,
                    folders: mailboxFolders,
                    users: users
                )
            )
        }
    }

    private func saveToCache(_ cache: MailboxCache) {
        cacheManager.save(cache, as: "mailboxes.json")
    }

    @MainActor
    private func mailboxesDidLoad(_ result: MailboxSyncResult) {
        delegate?.mailboxesDidLoad(result)
    }

    private func mailboxCacheUpdated(_ result: MailboxSyncResult) {
        delegate?.mailboxCacheLoaded(result)
    }
}
