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
    func folderDidLoad(_ result: [ConversationPreview])
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
    private var mailboxSyncResult: MailboxSyncResult?
    private var conversationsSyncResult = [ConversationPreview]()

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

                // Grab the Mailboxes
                let mailboxContainer = try await service.fetchMailboxes(
                    using: secret
                )

                // Create the objects for our result
                let users = usersContainer.embeddedUsers.users
                let mailboxes = mailboxContainer.embeddedMailboxes.mailboxes
                var mailboxFolders = [Int: Folders]()

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

                mailboxSyncResult = result
                mailboxesDidLoad(result)
                saveToCache(result.cache)
            } catch {
                print(error)
            }
        }
    }

    @MainActor func syncConversations(in folder: Folder) {
        guard let secret = secret else { return }
        Task {
            let result = try await service.fetchConversations(using: secret)
            let filtered = result.container.conversations.filter {
                $0.folderId == folder.id
            }
            conversationsSyncResult = sorted(filtered)
            folderDidLoad(conversationsSyncResult)
        }
    }

    private func loadMailboxesFromCache() {
        if let cached = cacheManager.load(
            MailboxCache.self,
            from: "mailboxes.json"
        ) {
            mailboxSyncResult = cached.syncResult
            mailboxCacheUpdated(cached.syncResult)
        }
    }

    private func saveToCache(_ cache: MailboxCache) {
        cacheManager.save(cache, as: "mailboxes.json")
    }

    // MARK: - Delegate Calls

    @MainActor
    private func mailboxesDidLoad(_ result: MailboxSyncResult) {
        delegate?.mailboxesDidLoad(result)
    }

    private func mailboxCacheUpdated(_ result: MailboxSyncResult) {
        delegate?.mailboxCacheLoaded(result)
    }

    @MainActor
    private func folderDidLoad(_ result: [ConversationPreview]) {
        delegate?.folderDidLoad(result)
    }

    // MARK: - Helper Methods

    func getFolder(section: Int, row: Int) -> Folder? {
        guard let result = mailboxSyncResult else { return nil }
        let mailbox = result.mailboxes[section]
        return result.folders[mailbox.id]?.container.folders[row]
    }

    // TODO: This will be removed when we sync and query CoreData
    private func sorted(_ conversations: [ConversationPreview]) -> [ConversationPreview] {
        let activeStatus = ConversationStatus.active.rawValue
        let active = conversations.filter { $0.status == activeStatus }
        let inactive = conversations.filter { $0.status != activeStatus }

        return active + inactive
    }
}
