//
//  MailboxTableViewCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/24/24.
//

import UIKit

class MailboxCell: BaseTableViewCell {
    static let reuseIdentifier = "MailboxCell"

    override func setupViews() {
        accessoryType = .disclosureIndicator
        backgroundColor = .cellTint

        let selectionView = UIView()
        selectionView.backgroundColor = .cellSelected

        selectedBackgroundView = selectionView
    }

    func configure(name: String) {
        var configuration = defaultContentConfiguration()
        configuration.text = name

        contentConfiguration = configuration
    }
}
