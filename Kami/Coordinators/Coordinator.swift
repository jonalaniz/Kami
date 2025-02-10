//
//  Coordinator.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

/// Coordinators manage the flow of the application by organizing view controllers and navigation logic.
/// They handle transitions between different sections of the app, allowing for clean separation of concerns
/// and improved modularity.
///
/// ### Key Responsibilities:
/// - Maintaining a collection of child coordinators to manage subflows.
/// - Managing the primary navigation container, such as a `UISplitViewController`.
/// - Starting or initializing the navigation flow.
///
/// - SeeAlso: `MainCoordinator`
protocol Coordinator: AnyObject {
    /// A collection of child coordinators used to manage sub-navigation flows.
    var childCoordinators: [Coordinator] { get set }

    /// The primary navigation container managed by the coordinator.
    var splitViewController: UISplitViewController { get set }

    /// Starts or initializes the navigation flow for this coordinator.
    func start()
}
