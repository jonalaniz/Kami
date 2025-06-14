//
//  ButtonCell.swift
//  Kami
//
//  Created by Jon Alaniz on 1/3/25.
//

import UIKit

/// A reusable table view cell that contains a single button.
///
/// The `ButtonCell` class provides a customizable button as its main view. It includes styling, constraints,
/// and a method to configure the button's title. This cell is intended for use in table views where a button
/// needs to be displayed as the primary interactive element.
class ButtonCell: BaseTableViewCell {
    /// The reuse identifier for the `ButtonCell`.
    static let reuseIdentifier = "ButtonCell"

    /// The button displayed within the cell.
    ///
    /// - By default, the button:
    ///   - Has rounded corners with a radius of 10.
    ///   - Uses the `.subHeaderToolbar` color for its background.
    ///   - Displays a `.selection` color for its title when disabled.
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.selection, for: .disabled)
        button.backgroundColor = .subHeaderToolbar
        button.layer.cornerRadius = 10
        return button
    }()

    /// Sets up the subviews of the cell.
    ///
    /// This method adds the `button` to the cell's view hierarchy and disables its autoresizing mask constraints
    /// to prepare it for Auto Layout.
    override func setupViews() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
    }

    /// Sets up the constraints for the button.
    ///
    /// The button is constrained to the edges of the cell, ensuring it fills the entire cell.
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    /// Configures the cell with a title for the button.
    ///
    /// - Parameter title: The title text to display on the button in its normal state.
    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }
}
