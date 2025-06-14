//
//  MailboxCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/24/24.
//

import UIKit

/// A custom table view cell that represents a mailbox in the app.
///
/// The `MailboxCell` is designed to display the name of a mailbox and indicate
/// that it can be tapped to reveal more details. It includes a disclosure indicator
/// and custom styling.
class MailboxCell: BaseTableViewCell {
    /// The reuse identifier for this cell.
    static let reuseIdentifier = "MailboxCell"

    /// Configures the initial appearance and behavior of the cell.
    ///
    /// - Sets the accessory type to a disclosure indicator.
    /// - Applies the inactive background color.
    /// - Adds a custom selected background view.
    override func setupViews() {
        accessoryType = .disclosureIndicator
        backgroundColor = .inactiveCell
        selectedBackgroundView = SelectedView()
    }

    /// Configures the cell with the given mailbox name.
    ///
    /// - Parameter name: The name of the mailbox to display.
    func configure(name: String) {
        var configuration = defaultContentConfiguration()
        configuration.text = name
        configuration.textProperties.color = .headerText

        contentConfiguration = configuration
    }
}
