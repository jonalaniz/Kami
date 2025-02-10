//
//  BaseDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 12/11/24.
//

import Foundation

class BaseDataManager: NSObject {
    /// A shared instance of `Configurator` that handles app and authentication specific configurations.
    let configurator: Configurator

    /// A shared instance of `FreeScoutService` that manages network interactions with FreeScout.
    let service: FreeScoutService

    /// A weak reference to the delegate responsible for handling data-related events.
    weak var delegate: DataManagerDelegate?

    /// Initializes the `BaseDataManager` with default or custom dependencies.
    ///
    /// - Parameters:
    ///   - configurator: The configurator responsible for managing app configurations. Defaults to
    ///   `Configurator.shared`.
    ///   - service: The FreeScout service responsible for handling network requests. Defaults to `FreeScoutService.shared`.
    init(configurator: Configurator = Configurator.shared, service: FreeScoutService = FreeScoutService.shared) {
        self.configurator = configurator
        self.service = service
    }

    /// Notifies the delegate that the data has been updated.
    ///
    /// This method must be called on the main thread using the `@MainActor` attribute to ensure UI updates
    /// are safe and synchronized.
    @MainActor
    func notifyDataUpdated() {
        self.delegate?.dataUpdated()
    }
}
