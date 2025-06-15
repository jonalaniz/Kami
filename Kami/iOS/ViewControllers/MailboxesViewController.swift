//
//  ViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class MailboxesViewController: BaseTableViewController {
    // MARK: - Properties

    private let mailboxesDataSource = MailboxDataSource()
    private var mailboxes = [Mailbox]()

    // MARK: - Lifecycle

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

    // MARK: - Setup

    override func setupView() {
        super.setupView()
        navigationItem.leftBarButtonItem = barButtonItem(
            .preferences,
            action: #selector(showPreferences)
        )
    }

    override func setupToolbar() {}

    override func registerCells() {
        tableView.register(
            MailboxCell.self,
            forCellReuseIdentifier: MailboxCell.reuseIdentifier
        )
    }

    // MARK: - Actions

    @objc func showPreferences() {
        coordinator?.showPreferences()
    }

    // MARK: - Data Handling

    func loadDataSource(_ result: MailboxSyncResult) {
        mailboxes = result.mailboxes
        mailboxesDataSource.update(
            mailboxes: result.mailboxes,
            folders: result.folders,
            users: result.users
        )
    }

    func reloadData(_ result: MailboxSyncResult) {
        loadDataSource(result)
        tableView.reloadData()
    }

    // MARK: - Helper Methods

    private func barButtonItem(_ symbol: Symbol, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: symbol.image(),
            style: .plain,
            target: self,
            action: action
        )
    }
}

// MARK: - UITableViewDelegate

extension MailboxesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showFolder(section: indexPath.section, row: indexPath.row)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderFooterView()
        headerView.configure(
            label: mailboxes[section].name,
            type: .header
        )

        return headerView
    }
}
