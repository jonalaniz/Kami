//
//  UIToolbarAppearance+DefaultAppearance.swift
//  Kami
//
//  Created by Jon Alaniz on 12/22/24.
//

import UIKit

extension UIToolbarAppearance {
    public static var defaultAppearance: UIToolbarAppearance {
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .toolbarTint

        toolbar?.standardAppearance = appearance
        toolbar?.scrollEdgeAppearance = appearance
        toolbar?.tintColor = .toolbarIconTint
    }
}
