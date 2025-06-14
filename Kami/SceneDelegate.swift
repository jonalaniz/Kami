//
//  SceneDelegate.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {
    var coordinator: MainCoordinator?
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { fatalError() }
        window = UIWindow(windowScene: windowScene)
        configureSplitViewController()
    }

    private func configureSplitViewController() {
        guard let window = window else { fatalError() }

        // Initialize a SplitViewController and Coordinator
        let splitViewController: UISplitViewController

        splitViewController = UISplitViewController()

        coordinator = MainCoordinator(splitViewController: splitViewController)
        coordinator?.start()

        // Setup our SplitViewController
        splitViewController.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        splitViewController.primaryBackgroundStyle = .sidebar
        splitViewController.delegate = self

        // Set the window to the SplitViewController
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()

        // Check for secrets
        coordinator?.loadSecret()
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return true
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
