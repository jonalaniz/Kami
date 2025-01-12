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
        // TODO: This needs to be changed to a "select mailbox view controller"
        detailNavigationController = UINavigationController(rootViewController: UIViewController())
    }

    // This is where we initialize the UISplitViewController
    func start() {
        mainViewController.coordinator = self

        // Initialize our SplitView
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        splitViewController.viewControllers = [mainNavigationController, detailNavigationController]
    }

    func showFolder(_ folder: Int, title: String) {
        if detailNavigationController.viewControllers.first != detailViewController {
            detailNavigationController.viewControllers = [detailViewController]
        }

        guard let navigationController = detailViewController.navigationController else { return }

        detailViewController.titleText = title
        detailViewController.controller.clear()
        detailViewController.controller.getConversations(for: folder)
        detailViewController.coordinator = self
        splitViewController.showDetailViewController(navigationController, sender: nil)
    }

    func showConversation(_ conversation: Int, title: String) {

    }
}
