//
//  ConversationHeaderCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/17/24.
//

import UIKit

// swiftlint:disable identifier_name
class ConversationHeaderCell: BaseTableViewCell {
    static let reuseIdentifier = "ConversationHeaderCell"

    private var senderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .headerText
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    private var toLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        return label
    }()

    private var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text

        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    private var topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4

        return stackView
    }()

    private var bottomHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4

        return stackView
    }()

    private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12

        return stackView
    }()

    override func setupViews() {
        backgroundColor = .sidebar
        selectionStyle = .none

        // Add the topHorizontalStackView views
        topHorizontalStackView.addArrangedSubview(senderLabel)
        topHorizontalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(topHorizontalStackView)

        // Add the bottomHorizontalStackView views
        bottomHorizontalStackView.addArrangedSubview(toLabel)
        bottomHorizontalStackView.addArrangedSubview(statusLabel)
        verticalStackView.addArrangedSubview(bottomHorizontalStackView)

        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalStackView)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(sender: String,
                   date: String,
                   to: [String]?,
                   assignedTo: ConversationUser?,
                   status: String) {
        senderLabel.text = sender
        dateLabel.text = date.formattedDate()

        let toText: String
        if let to = to {
            toText = "To: " +  to.joined(separator: ", ")
        } else {
            toText = ""
        }
        toLabel.text = toText

        statusLabel.text = status
    }
}
