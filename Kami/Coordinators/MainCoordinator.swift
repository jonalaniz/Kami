//
//  MainCoordinator.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    // MARK: - Properties

    let mainViewController: MailboxesViewController
    let detailNavigationController: UINavigationController
    let detailViewController: FolderViewController

    private let configurator = Configurator.shared
    private let dataSyncManager = DataSyncManager.shared

    var childCoordinators = [Coordinator]()
    var splitViewController: UISplitViewController

    // MARK: - Lifecycle

    /// Initializes the `MainCoordinator` with the given split view controller.
    ///
    /// - Parameter splitViewController: The `UISplitViewController` instance to manage.
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController

        mainViewController = MailboxesViewController()
        detailViewController = FolderViewController()
        detailNavigationController = UINavigationController(rootViewController: detailViewController)
    }

    func start() {
        // Set our delegates/coordinators
        mainViewController.coordinator = self
        dataSyncManager.delegate = self

        // Initialize our SplitView
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        detailNavigationController.viewControllers = [detailViewController]
        splitViewController.viewControllers = [mainNavigationController, detailNavigationController]
    }

    @MainActor func loadSecret() {
        // Call the Credentials Manager and see if there is a valid key
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

    func showLoginView() {

    }

    /// Displays a folder and its associated conversations in the detail view.
    ///
    /// - Parameters:
    ///   - folder: The ID of the folder to display.
    ///   - title: The title of the folder to display in the navigation bar.
    func showFolder(section: Int, row: Int) {
        guard let folder = dataSyncManager.getFolder(section: section, row: row) else { return }
        detailViewController.titleText = folder.name
        detailViewController.dataManager.clear()
        detailViewController.dataManager.getConversations(for: folder.id)
        detailViewController.coordinator = self

        if detailNavigationController.topViewController != detailViewController {
            detailNavigationController.setViewControllers([detailViewController], animated: true)
        }

        splitViewController.showDetailViewController(detailNavigationController, sender: nil)
    }

    /// Displays a specific conversation in the detail navigation stack.
    ///
    /// - Parameters:
    ///   - conversation: The ID of the conversation to display.
    ///   - title: The title of the conversation to display in the navigation bar.
    func showConversation(_ conversation: Int, title: String) {
        let conversationViewController = ConversationViewController()
        conversationViewController.titleText = title
        conversationViewController.dataManager.clear()
        conversationViewController.dataManager.getConversation(conversation)

        detailNavigationController.pushViewController(conversationViewController, animated: true)
    }

    /// Presents the preferences screen as a modal popover.
    ///
    /// This method displays the `PreferencesViewController` in a navigation controller modally.
    func showPreferences() {
        print("showPreferencesCalled")
        let popoverNavigationController = UINavigationController(rootViewController: PreferencesViewController())
        splitViewController.present(popoverNavigationController, animated: true)
    }

    /// Reloads the list of mailboxes in the main view.
    ///
    /// This method triggers a data fetch operation for the `MailboxesViewController` to update the mailbox list.
    @MainActor func reloadMailboxes() {
        dataSyncManager.syncMailboxStructure()
    }
}

extension MainCoordinator: DataSyncManagerDelegate {
    func mailboxCacheLoaded(_ result: MailboxSyncResult) {
        mainViewController.loadDataSource(result)
    }

    func mailboxesDidLoad(_ result: MailboxSyncResult) {
        mainViewController.reloadData(result)
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
