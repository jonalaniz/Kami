//
//  ViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class MailboxesViewController: BaseTableViewController {
    let dataManager = MailboxDataManager.shared

    override func viewDidLoad() {
        dataSource = dataManager
        delegate = dataManager
        titleText = "All Mailboxes"
        tableStyle = .insetGrouped
        super.viewDidLoad()
        dataManager.delegate = self
        dataManager.getData()
    }
}

extension MailboxesViewController: ControllerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }

    func controllerDidSelect(_ item: Int, title: String) {
        coordinator?.showFolder(item, title: title)
    }

    func tableViewHeightUpdated() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

