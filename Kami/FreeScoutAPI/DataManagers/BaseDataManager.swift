//
//  BaseDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 12/11/24.
//

import Foundation

class BaseDataManager: NSObject {
    let configurator: Configurator
    let service: FreeScoutService
    weak var delegate: DataManagerDelegate?

    init(configurator: Configurator = Configurator.shared, service: FreeScoutService = FreeScoutService.shared) {
        self.configurator = configurator
        self.service = service
    }

    @MainActor
    func notifyDataUpdated() {
        self.delegate?.dataUpdated()
    }

    @MainActor
    func controllerDidSelect(_ int: Int, title: String) {
        self.delegate?.controllerDidSelect(int, title: title)
    }
}
