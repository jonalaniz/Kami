//
//  ConversationTableViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 12/11/24.
//

import UIKit
import WebKit

class ConversationViewController: BaseTableViewController {
    let dataManager = ConversationDataManager.shared

    override func viewDidLoad() {
        dataSource = dataManager
        dataSource = dataManager
        navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        dataManager.delegate = self
    }

    override func registerCells() {
        tableView.register(ConversationHeaderCell.self,
                           forCellReuseIdentifier: ConversationHeaderCell.reuseIdentifier)
        tableView.register(ConversationBodyCell.self,
                           forCellReuseIdentifier: ConversationBodyCell.reuseIdentifier)
    }

    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
    }

    override func setupToolbar() {
        toolbarItems = [
            barButtonItem(.reply, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.notes, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.bell, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.forward, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.merge, action: #selector(buttonPressed)),
            UIBarButtonItem.flexibleSpace(),
            barButtonItem(.trash, action: #selector(buttonPressed))
        ]
        super.setupToolbar()
    }

    private func barButtonItem(_ symbol: Symbol, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: symbol.image(),
                               style: .plain,
                               target: self,
                               action: action)
    }
}

extension ConversationViewController: DataManagerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }
    
    func tableViewHeightUpdated() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
