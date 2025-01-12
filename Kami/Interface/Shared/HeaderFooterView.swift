//
//  MailboxHeaderView.swift
//  Kami
//
//  Created by Jon Alaniz on 12/24/24.
//

import UIKit

enum HeaderFooterType {
    case header
    case footer
}

class HeaderFooterView: UIView {
    let headerLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("NSCoder not implemented")
    }

    private func setupView() {
        headerLabel.numberOfLines = 0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = .iconsMainToolbar

        addSubview(headerLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(label: String?, type: HeaderFooterType) {
        headerLabel.text = label

        let font: UIFont

        switch type {
        case .header: font = .preferredFont(forTextStyle: .headline)
        case .footer: font = .preferredFont(forTextStyle: .footnote)
        }

        headerLabel.font = font
    }
}
