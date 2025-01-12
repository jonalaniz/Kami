//
//  ConversationTableViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 12/11/24.
//

import UIKit

class ConversationViewController: BaseTableViewController {
    let dataManager = ConversationDataManager.shared

    override func viewDidLoad() {
        dataSource = dataManager
        dataSource = dataManager
        super.viewDidLoad()
        dataManager.delegate = self
    }
}

extension ConversationViewController: ControllerDelegate {

}

class ConversationDataManager: BaseDataManager {
    static let shared = ConversationDataManager(configurator: Configurator.shared,
                                                service: FreeScoutService.shared)
    var conversation: Conversation?

    private override init(configurator: Configurator, service: FreeScoutService) {
        super.init(configurator: configurator, service: service)
    }

    // TODO: We need to grab any assets from the conversation
}

extension ConversationDataManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversation?.embedded.threads.count ?? 0
    }
}
