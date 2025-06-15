//
//  FolderDataSource.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import UIKit

final class FolderDataSource: NSObject, UITableViewDataSource {
    // MARK: - Internal State

    private var conversations = [ConversationPreview]()

    // MARK: - Public API

    /// Updates the internal data used to render the table view.
    ///
    ///  - Parameters:
    ///    - conversations: The list of ConversationsPreviews in the folder.
    func update(_ conversations: [ConversationPreview]) {
        self.conversations = conversations
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationPreviewCell.reuseIdentifier
        ) as? ConversationPreviewCell
        else {
            fatalError(
                "DequeueReusableCell failed while casting as ConversationCell"
            )
        }
        let conversation = conversations[indexPath.row]
        cell.configure(with: conversation)
        return cell
    }
}
