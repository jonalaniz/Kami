//
//  ViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class MailboxesViewController: BaseTableViewController {
    let mailboxesDataSource = MailboxDataSource()

    override func viewDidLoad() {
        dataSource = mailboxesDataSource
        delegate = self
        titleText = "All Mailboxes"
        tableStyle = .insetGrouped
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if navigationController?.toolbar.isHidden == false {
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }

    override func registerCells() {
        tableView.register(
            MailboxCell.self,
            forCellReuseIdentifier: MailboxCell.reuseIdentifier
        )
    }

    override func setupView() {
        super.setupView()
        navigationItem.leftBarButtonItem = barButtonItem(
            .preferences, action: #selector(showPreferences)
        )
    }

    override func setupToolbar() {}

    @objc func showPreferences() {
        coordinator?.showPreferences()
    }

    func loadDataSource(_ result: MailboxSyncResult) {
        mailboxesDataSource.update(
            mailboxes: result.mailboxes,
            folders: result.folders,
            users: result.users
        )
    }

    func reloadData(_ result: MailboxSyncResult) {
        loadDataSource(result)
        print(tableView.contentSize)
        print(tableView.frame)
        tableView.reloadData()
        print(tableView.contentSize)
        print(tableView.frame)

    }

    private func barButtonItem(_ symbol: Symbol, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: symbol.image(),
            style: .plain,
            target: self,
            action: action
        )
    }
}

extension MailboxesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showFolder(section: indexPath.section, row: indexPath.row)
    }
}
