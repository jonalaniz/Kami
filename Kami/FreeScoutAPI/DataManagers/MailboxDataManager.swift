//
//  MailboxDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 12/2/24.
//

import UIKit

class MailboxDataManager: BaseDataManager {
    static let shared = MailboxDataManager(configurator: Configurator.shared,
                                           service: FreeScoutService.shared)

    var mailboxes = [Mailbox]()
    var mailboxFolders = [Int: Folders]()
    var users = [User]()

    private override init(configurator: Configurator, service: FreeScoutService) {
        super.init(configurator: configurator, service: service)
    }

    func getData() {
        guard let secret = configurator.secret else { return  }
        Task {
            do {
                let usersContainer = try await service.fetchUsers()
                users = usersContainer.embeddedUsers.users

                let mailboxesContainer = try await service.fetchMailboxes(key: secret.key,
                                                              url: secret.url)
                mailboxes = mailboxesContainer.embeddedMailboxes.mailboxes

                for mailbox in mailboxes {
                    let folders = try await service.fetchFolders(for: mailbox.id)
                    mailboxFolders[mailbox.id] = folders
                }

                await notifyDataUpdated()
            } catch {
                print(error)
            }
        }
    }


}

extension MailboxDataManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = mailboxes[indexPath.section].id
        let folder = mailboxFolders[id]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MailboxCell.reuseIdentifier) as? MailboxCell
        else { fatalError("DequeueReusableCell failed while casting as MailboxCell") }

        let name = name(of: folder?.container.folders[indexPath.row])
        cell.configure(name: name)

        return cell
    }

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
            label: tableView.dataSource?.tableView?(tableView,
                                                    titleForHeaderInSection: section),
            type: .header
        )

        return headerView
    }

    func name(of folder: Folder?) -> String {
        guard let folder = folder else { return "" }
        switch folder.name {
        case "Mine":
            guard let user = users.first(where: { $0.id == folder.userId })
            else { return "User's Conversations" }
            return "\(user.name())'s Conversations"
        case "Starred":
            guard let user = users.first(where: { $0.id == folder.userId })
            else { return "Starred by user" }
            return "Starred by \(user.name())"
        default:
            return folder.name
        }
    }
}
