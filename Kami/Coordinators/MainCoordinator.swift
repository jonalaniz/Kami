//
//  MainCoordinator.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var splitViewController: UISplitViewController

    let mainViewController: MailboxesViewController
    let detailNavigationController: UINavigationController
    let detailViewController: FolderViewController


    /// Initializes the `MainCoordinator` with the given split view controller.
    ///
    /// - Parameter splitViewController: The `UISplitViewController` instance to manage.
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController

        mainViewController = MailboxesViewController()
        detailViewController = FolderViewController()
        detailNavigationController = UINavigationController(rootViewController: detailViewController)
    }

    /// Starts the coordinator by configuring and displaying the split view interface.
    ///
    /// This method sets up the `mainViewController` and `detailViewController` within the `UISplitViewController` and establishes the initial navigation hierarchy.
    func start() {
        mainViewController.coordinator = self

        // Initialize our SplitView
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        detailNavigationController.viewControllers = [detailViewController]
        splitViewController.viewControllers = [mainNavigationController, detailNavigationController]
    }

    /// Displays a folder and its associated conversations in the detail view.
    ///
    /// - Parameters:
    ///   - folder: The ID of the folder to display.
    ///   - title: The title of the folder to display in the navigation bar.
    func showFolder(_ folder: Int, title: String) {
        detailViewController.titleText = title
        detailViewController.dataManager.clear()
        detailViewController.dataManager.getConversations(for: folder)
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
        let popoverNavigationController = UINavigationController(rootViewController: PreferencesViewController())
        splitViewController.present(popoverNavigationController, animated: true)
    }

    /// Reloads the list of mailboxes in the main view.
    ///
    /// This method triggers a data fetch operation for the `MailboxesViewController` to update the mailbox list.
    func reloadMailboxes() {
        mainViewController.dataManager.getData()
    }
}
