//
//  UIToolbar+SetDefaultAppearance.swift
//  Kami
//
//  Created by Jon Alaniz on 12/22/24.
//

import UIKit

extension UIToolbar {
    func setDefaultAppearance() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .toolbarTint

        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        self.tintColor = .toolbarIconTint
    }
}
