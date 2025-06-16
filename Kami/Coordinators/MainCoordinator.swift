//
//  MainCoordinator.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    // MARK: - Dependencies

    private let configurator = Configurator.shared
    private let dataSyncManager = DataSyncManager.shared

    // MARK: - View Controllers

    let mainViewController = MailboxesViewController()
    let detailViewController = FolderViewController()
    let detailNavigationController: UINavigationController
    var splitViewController: UISplitViewController

    // MARK: - Coordinator State

    var childCoordinators = [Coordinator]()

    // MARK: - Init

    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
        detailNavigationController = UINavigationController(
            rootViewController: detailViewController
        )
    }

    // MARK: - Start

    func start() {
        // Set our delegates/coordinators
        mainViewController.coordinator = self
        detailViewController.coordinator = self
        dataSyncManager.delegate = self

        // Initialize our SplitView
        let mainNavigationController = UINavigationController(
            rootViewController: mainViewController
        )
        splitViewController.viewControllers = [
            mainNavigationController,
            detailNavigationController
        ]
    }

    // MARK: - Sync

    @MainActor func loadSecret() {
        guard let secret = configurator.secret else {
            print("no secrets")
            showLoginView()
            showPreferences()
            return
        }

        // Seed the DataSyncManager
        dataSyncManager.secret = secret
        dataSyncManager.syncMailboxStructure()
    }

    @MainActor func reloadMailboxes() {
        dataSyncManager.syncMailboxStructure()
    }

    @MainActor func loadConversations(for folder: Folder) {
        dataSyncManager.syncConversations(in: folder)
    }

    // MARK: - Navigation

    func showLoginView() {
        // TODO: Implement loginView, potentially in future Auth Coordinator
    }

    func showPreferences() {
        let navigationController = UINavigationController(
            rootViewController: PreferencesViewController()
        )
        splitViewController.present(navigationController, animated: true)
    }

    @MainActor func showFolder(section: Int, row: Int) {
        guard let folder = dataSyncManager.getFolder(section: section, row: row)
        else { return }
        detailViewController.titleText = folder.name
        detailViewController.clearDataSource()

        loadConversations(for: folder)

        if detailNavigationController.topViewController != detailViewController {
            detailNavigationController.setViewControllers(
                [detailViewController],
                animated: true
            )
        }

        splitViewController.showDetailViewController(
            detailNavigationController,
            sender: nil
        )
    }

    func showConversation(row: Int) {
        guard let conversation = dataSyncManager.getConversation(row: row) else { return }
        let viewController = ConversationViewController()
        viewController.titleText = conversation.subject
        viewController.dataManager.clear()
        viewController.dataManager.getConversation(conversation.id)

        detailNavigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - DataSyncManagerDelegate
// TODO: Move this to it's own file after CoreData implementaiton.

extension MainCoordinator: DataSyncManagerDelegate {
    func mailboxCacheLoaded(_ result: MailboxSyncResult) {
        mainViewController.loadDataSource(result)
    }

    func mailboxesDidLoad(_ result: MailboxSyncResult) {
        mainViewController.reloadData(result)
    }

    func folderDidLoad(_ result: [ConversationPreview]) {
        detailViewController.updateDataSource(result)
    }

    func syncDidStart() {
        print("sync did start")
    }

    func syncDidFinish() {
        print("sync did finish")
    }

    func syncDidFail(with error: any Error) {
        print("sync did fail")
    }
}
