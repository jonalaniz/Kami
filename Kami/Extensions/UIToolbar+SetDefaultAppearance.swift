//
//  UIToolbar+SetDefaultAppearance.swift
//  Kami
//
//  Created by Jon Alaniz on 12/22/24.
//

import UIKit

extension UIToolbar {
    /// Configures the toolbar's appearance with custom background and tint colors.
    ///
    /// This method updates the toolbar's appearance using a `UIToolbarAppearance` object,
    /// allowing you to set both the background color and the tint color for items within the toolbar.
    /// It applies the appearance to both the standard and scroll edge appearances for consistency.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let toolbar = UIToolbar()
    /// toolbar.setColors(background: .black, tint: .white)
    /// ```
    ///
    /// - Parameters:
    ///   - background: The background color of the toolbar.
    ///   - tint: The tint color for the toolbar items.
    func setColors(background: UIColor, tint: UIColor) {
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = background

        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        self.tintColor = tint
    }
}
