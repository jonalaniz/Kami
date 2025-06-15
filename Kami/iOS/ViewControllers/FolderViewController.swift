//
//  FolderViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class FolderViewController: BaseTableViewController {
    // MARK: - Properties

    private let folderDataSource = FolderDataSource()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        dataSource = folderDataSource
        delegate = self
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        title = titleText

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Setup

    override func setupToolbar() {
        toolbarItems = [
            barButtonItem(.preferences, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.envelope, action: #selector(buttonPressed))
        ]
        super.setupToolbar()
    }

    override func registerCells() {
        tableView.register(
            ConversationPreviewCell.self,
            forCellReuseIdentifier: ConversationPreviewCell.reuseIdentifier
        )
    }

    // MARK: - Actions

    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
    }

    // MARK: - Data Handling

    func clearDataSource() {
        updateDataSource([ConversationPreview]())
    }

    func updateDataSource(_ conversations: [ConversationPreview]) {
        folderDataSource.update(conversations)
        guard tableView != nil else { return }
        tableView.reloadData()
    }

    // MARK: - Helper Methods

    private func barButtonItem(_ symbol: Symbol, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: symbol.image(),
                               style: .plain,
                               target: self,
                               action: action)
    }
}

extension FolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected folder at: \(indexPath.row)")
        // TODO: This needs to be called from Coordinator
//        let conversation = dataManager.conversations[indexPath.row]
//        coordinator?.showConversation(conversation.id, title: conversation.subject)
    }
}

extension FolderViewController: DataManagerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }

    func tableViewHeightUpdated() {}
}
