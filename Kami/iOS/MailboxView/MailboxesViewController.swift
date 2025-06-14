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
        delegate = self
        titleText = "All Mailboxes"
        tableStyle = .insetGrouped
        super.viewDidLoad()
        dataManager.delegate = self
        dataManager.getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if navigationController?.toolbar.isHidden == false {
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }

    override func registerCells() {
        tableView.register(MailboxCell.self,
                           forCellReuseIdentifier: MailboxCell.reuseIdentifier)
    }

    override func setupView() {
        super.setupView()
        navigationItem.leftBarButtonItem = barButtonItem(.preferences, action: #selector(showPreferences))
    }

    override func setupToolbar() {}

    @objc func showPreferences() {
        coordinator?.showPreferences()
    }

    private func barButtonItem(_ symbol: Symbol, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: symbol.image(),
                               style: .plain,
                               target: self,
                               action: action)
    }
}

extension MailboxesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mailboxID = dataManager.mailboxes[indexPath.section].id
        guard let folder = dataManager.mailboxFolders[mailboxID]?.container.folders[indexPath.row]
        else { return }

        coordinator?.showFolder(folder.id, title: dataManager.name(of: folder))
    }
}

extension MailboxesViewController: DataManagerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }

    func tableViewHeightUpdated() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

