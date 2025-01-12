//
//  Coordinator.swift
//  Kami
//
//  Created by Jon Alaniz on 11/30/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var splitViewController: UISplitViewController { get set }

    func start()
}
