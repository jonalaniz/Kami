//
//  PreferencesViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 12/30/24.
//

import UIKit

class PreferencesViewController: BaseTableViewController {
    let dataManager = PreferencesDataManager.shared

    override func viewDidLoad() {
        titleText = Constants.preferences
        tableStyle = .insetGrouped
        dataSource = dataManager
        delegate = self
        dataManager.delegate = self
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func setupView() {
        super.setupView()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        updateRightBarButton()
    }

    override func registerCells() {
        tableView.register(InputCell.self,
                           forCellReuseIdentifier: InputCell.reuiseIdentifier)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseIdentifier)
    }

    @objc func cancel() {
        coordinator?.reloadMailboxes()
        dismiss(animated: true)
    }

    @objc func signIn() {
        dataManager.signIn()
    }

    @objc func signOut() {
        dataManager.signOut()
    }

    private func updateRightBarButton() {
        let title = dataManager.isSignedIn ? Constants.signOut : Constants.signIn
        let action = dataManager.isSignedIn ? #selector(signOut) : #selector(signIn)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem?.isEnabled = false

        guard dataManager.hasValidCredentials() else { return }

        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = PreferencesSection(rawValue: section)
        else { return nil }

        switch section {
        case .signIn:
            let label = dataManager.isSignedIn ? Constants.freeScoutInstance : Constants.signIn
            return headerFooterView(with: label, type: .header)
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let section = PreferencesSection(rawValue: section)
        else { return nil }

        switch section {
        case .signIn: return headerFooterView(with: Constants.preferencesFooter,
                                              type: .footer)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    private func headerFooterView(with label: String, type: HeaderFooterType) -> UIView {
        let view = HeaderFooterView()
        view.configure(label: label, type: type)
        return view
    }
}

extension PreferencesViewController: DataManagerDelegate {
    // Called when the dataManager either updates the sign in status or
    // credentials are entered and are valid
    func dataUpdated() {
        print("Data updated")

        // Update the right bar button item based on isSignedIn()
        updateRightBarButton()

        // Update the tableView to be editable based on isSignedIn()
        tableView.reloadData()
    }
    
    func controllerDidSelect(_ selection: Int, title: String) {}
    
    func tableViewHeightUpdated() {}
}
