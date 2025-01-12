//
//  FolderViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class FolderViewController: BaseTableViewController {
    let dataManager = FolderDataManager.shared

    override func viewDidLoad() {
        dataSource = dataManager
        delegate = dataManager
        super.viewDidLoad()
        dataManager.delegate = self
    }

    override func registerCells() {
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "Cell")
    }

    func setupToolbar() {
        
    }
}

extension FolderViewController: ControllerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }

    func controllerDidSelect(_ selection: Int, title: String) {
        coordinator?.showConversation(selection, title: title)
    }

    func tableViewHeightUpdated() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
