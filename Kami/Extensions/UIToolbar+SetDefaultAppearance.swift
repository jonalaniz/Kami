//
//  UIToolbar+SetDefaultAppearance.swift
//  Kami
//
//  Created by Jon Alaniz on 12/22/24.
//

import UIKit

extension UIToolbar {
    func setColors(background: UIColor, tint: UIColor) {
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = background

        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        self.tintColor = tint
    }
}
