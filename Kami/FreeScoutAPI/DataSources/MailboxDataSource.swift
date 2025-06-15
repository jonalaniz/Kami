//
//  MailboxDataSource.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import UIKit

// swiftlint:disable identifier_name

/// A data source for rendering mailbox sections and folders in a `UITableView`.
final class MailboxDataSource: NSObject, UITableViewDataSource {
    // MARK: - Internal State

    private var mailboxes = [Mailbox]()
    private var mailboxFolders = [Int: Folders]()
    private var users = [User]()

    // MARK: - Public API

    /// Updates the internal data used to render the table view.
    /// 
    /// - Parameters:
    ///   - mailboxes: The list of mailboxes.
    ///   - folders: A mapping from mailbox ID to its folders.
    ///   - users: The list of users used for folder labeling.
    func update(mailboxes: [Mailbox], folders: [Int: Folders], users: [User]) {
        self.mailboxes = mailboxes
        self.mailboxFolders = folders
        self.users = users
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return mailboxes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let id = mailboxes[section].id
        return mailboxFolders[id]?.container.folders.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mailboxes[section].name
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderFooterView()
        headerView.configure(
            label: mailboxes[section].name,
            type: .header
        )

        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = mailboxes[indexPath.section].id

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MailboxCell.reuseIdentifier
            ) as? MailboxCell,
            let folder = mailboxFolders[id]?.container.folders[indexPath.row]
        else {
            assertionFailure("DequeueReusableCell failed while casting as MailboxCell")
            return UITableViewCell()
        }

        let name = name(of: folder)
        cell.configure(name: name)

        return cell
    }

    // MARK: - Helpers

    /// Returns a human-readable name for a folder, accounting for user-owned folders.
    private func name(of folder: Folder?) -> String {
        guard let folder = folder else { return "" }

        if let user = users.first(where: {$0.id == folder.userId }) {
            switch folder.name {
            case "Mine": return "\(user.name())'s Conversations"
            case "Starred": return "Starred by \(user.name())"
            default: break
            }
        }

        return folder.name
    }
}
