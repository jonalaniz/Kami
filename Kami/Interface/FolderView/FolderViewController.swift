//
//  FolderViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

/// A view controller responsible for displaying a list of conversations within a specific folder.
///
/// The `FolderViewController` manages the user interface for viewing and interacting with conversations.
/// It integrates with the `FolderDataManager` to fetch and display the necessary data.
class FolderViewController: BaseTableViewController {
    let dataManager = FolderDataManager.shared

    override func viewDidLoad() {
        dataSource = dataManager
        delegate = self
        super.viewDidLoad()
        dataManager.delegate = self
    }

    override func registerCells() {
        tableView.register(ConversationPreviewCell.self,
                           forCellReuseIdentifier: ConversationPreviewCell.reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        title = titleText

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func setupToolbar() {
        toolbarItems = [
            barButtonItem(.preferences, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.envelope, action: #selector(buttonPressed))
        ]
        super.setupToolbar()
    }

    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
    }

    private func barButtonItem(_ symbol: Symbol, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: symbol.image(),
                               style: .plain,
                               target: self,
                               action: action)
    }
}

extension FolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = dataManager.conversations[indexPath.row]
        coordinator?.showConversation(conversation.id, title: conversation.subject)
    }
}

extension FolderViewController: DataManagerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }

    func tableViewHeightUpdated() {}
}
