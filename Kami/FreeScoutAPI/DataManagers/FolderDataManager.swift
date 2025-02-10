//
//  FolderDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 12/2/24.
//

import UIKit

class FolderDataManager: BaseDataManager {
    static let shared = FolderDataManager(configurator: Configurator.shared,
                                          service: FreeScoutService.shared)

    var conversations = [ConversationPreview]()

    private override init(configurator: Configurator, service: FreeScoutService) {
        super.init(configurator: configurator, service: service)
    }

    func getConversations(for folder: Int) {
        Task {
            let object = try await service.fetchConversations()
            let filtered = object.container.conversations.filter { $0.folderId == folder }
            conversations = sorted(filtered)
            await notifyDataUpdated()
        }
    }

    func clear() {
        conversations.removeAll()
        delegate?.dataUpdated()
    }

    private func sorted(_ conversations: [ConversationPreview]) -> [ConversationPreview] {
        var active = [ConversationPreview]()
        var inactive = [ConversationPreview]()
        let activeStatus = ConversationStatus.active.rawValue

        conversations.forEach {
            print($0.id)
            $0.status == activeStatus ? active.append($0) : inactive.append($0)
        }

        return active + inactive
    }
}

extension FolderDataManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = conversationCellFor(conversations[indexPath.row], in: tableView)
        return cell
    }

    // MARK: - Helper Functions
    private func conversationCellFor(_ conversation: ConversationPreview, in tableView: UITableView) -> ConversationPreviewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationPreviewCell.reuseIdentifier) as? ConversationPreviewCell
        else { fatalError("DequeueReusableCell failed while casting as ConversationCell") }

        cell.configure(with: conversation)

        return cell
    }
}
