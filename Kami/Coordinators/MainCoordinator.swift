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

    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController

        mainViewController = MailboxesViewController()
        detailViewController = FolderViewController()
        detailNavigationController = UINavigationController(rootViewController: detailViewController)
    }

    // This is where we initialize the UISplitViewController
    func start() {
        mainViewController.coordinator = self

        // Initialize our SplitView
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        detailNavigationController.viewControllers = [detailViewController]
        splitViewController.viewControllers = [mainNavigationController, detailNavigationController]
    }

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

    func showConversation(_ conversation: Int, title: String) {
        // Step 1: Instantiate the ConversationViewController
        let conversationViewController = ConversationViewController()
        conversationViewController.titleText = title
        conversationViewController.dataManager.clear()
        conversationViewController.dataManager.getConversation(conversation)

        // Step 2: Push or replace the view controller in the detail navigation stack
        detailNavigationController.pushViewController(conversationViewController, animated: true)
    }

    func showPreferences() {
        let popoverNavigationController = UINavigationController(rootViewController: PreferencesViewController())
        splitViewController.present(popoverNavigationController, animated: true)
    }

    func reloadMailboxes() {
        mainViewController.dataManager.getData()
    }
}
