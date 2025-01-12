//
//  ConversationPreviewCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import UIKit

class ConversationPreviewCell: BaseTableViewCell {
    static let reuseIdentifier = "ConversationPreviewCell"
    
    private var senderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .headerText
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()

    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    private var subjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .headerText
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        return label
    }()

    private var previewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    override func setupViews() {
        selectedBackgroundView = SelectedView()
        accessoryType = .disclosureIndicator
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(senderLabel)
        stackView.addArrangedSubview(subjectLabel)
        stackView.addArrangedSubview(previewLabel)
        contentView.addSubview(stackView)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with conversation: ConversationPreview) {
        senderLabel.text = conversation.customer?.name()
        subjectLabel.text = conversation.subject
        previewLabel.text = conversation.preview

        // Here we configure the bkcolor
        guard let status = ConversationStatus(rawValue: conversation.status)
        else {
            backgroundColor = .inactiveCell
            return
        }

        setBackgroundColor(for: status)
    }

    private func setBackgroundColor(for status: ConversationStatus) {
        switch status {
        case .active: backgroundColor = .activeCell
        default: backgroundColor = .inactiveCell
        }
    }
}

enum ConversationStatus: String {
    case active = "active"
    case closed = "closed"
    case pending = "pending"
    case spam = "spam"
}
