//
//  ConversationCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import UIKit

class ConversationPreviewCell: UITableViewCell {
    private var senderLabel: UILabel = {
        let label = UILabel()
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
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        return label
    }()

    private var previewLabel: UILabel = {
        let label = UILabel()
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with conversation: ConversationPreview) {
        senderLabel.text = conversation.customer?.name()
        subjectLabel.text = conversation.subject
        previewLabel.text = conversation.preview
    }

    private func setupLayout() {
        backgroundColor = .cellTint
        accessoryType = .disclosureIndicator
        stackView.addArrangedSubview(senderLabel)
        stackView.addArrangedSubview(subjectLabel)
        stackView.addArrangedSubview(previewLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
