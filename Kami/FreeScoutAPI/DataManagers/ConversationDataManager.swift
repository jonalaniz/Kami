//
//  ConversationDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 12/22/24.
//

import UIKit

// swiftlint:disable identifier_name
class ConversationDataManager: BaseDataManager {
    static let shared = ConversationDataManager(
        configurator: Configurator.shared,
        service: FreeScoutService.shared
    )
    var conversation: Conversation?

    private override init(configurator: Configurator, service: FreeScoutService) {
        super.init(configurator: configurator, service: service)
    }

    func getConversation(_ id: Int) {
        guard let secret = configurator.secret else { return }
        Task {
            let object = try await service.fetchConversation(
                id, using: secret
            )
            conversation = object
            await notifyDataUpdated()
        }
    }

    func clear() {
        conversation = nil
        delegate?.dataUpdated()
    }
}

extension ConversationDataManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let thread = conversation?.embedded.threads[indexPath.section]
        else { return UITableViewCell() }

        let cell: UITableViewCell

        switch indexPath.row {
        case 0: cell = headerCellFor(thread, in: tableView)
        case 1: cell = bodyCellFor(thread, in: tableView)
        default: cell = UITableViewCell()
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return conversation?.embedded.threads.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Helper Functions
    private func headerCellFor(
        _ thread: Thread,
        in tableView: UITableView
    ) -> ConversationHeaderCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationHeaderCell.reuseIdentifier
        ) as? ConversationHeaderCell
        else { fatalError("DequeueReusableCell failed while casting as ConversationHeaderCell") }

        cell.configure(sender: thread.createdBy?.displayName ?? "",
                       date: thread.createdAt,
                       to: thread.to,
                       assignedTo: thread.assignedTo,
                       status: thread.status)

        return cell
    }

    private func bodyCellFor(
        _ thread: Thread,
        in tableView: UITableView
    ) -> ConversationBodyCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationBodyCell.reuseIdentifier
        ) as? ConversationBodyCell
        else { fatalError("DequeueReusableCell failed while casting as ConversationBodyCell") }

        if let body = thread.body {
            cell.loadHTMLContent(body)
        }

        // Handle dynamic height updates
        cell.onHeightChange = {
            DispatchQueue.main.async {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }

        return cell
    }
}
