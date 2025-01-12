//
//  ButtonCell.swift
//  Kami
//
//  Created by Jon Alaniz on 1/3/25.
//

import UIKit

class ButtonCell: BaseTableViewCell {
    static let reuseIdentifier = "ButtonCell"

    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.selection, for: .disabled)
        button.backgroundColor = .subHeaderToolbar
        button.layer.cornerRadius = 10
        return button
    }()

    override func setupViews() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }
}

