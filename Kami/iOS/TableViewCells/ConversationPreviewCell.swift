//
//  ConversationPreviewCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import UIKit

/// A custom table view cell that displays a preview of a conversation.
///
/// The `ConversationPreviewCell` is designed to show key information about a conversation,
/// such as the sender, subject, preview text, and a visual indicator for its status.
class ConversationPreviewCell: BaseTableViewCell {

    /// The reuse identifier for this cell.
    static let reuseIdentifier = "ConversationPreviewCell"

    /// A label to display the name of the sender.
    private var senderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .headerText
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()

    /// A label to display the timestamp of the conversation.
    private var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    /// A label to display the subject of the conversation.
    private var subjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .headerText
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        return label
    }()

    /// A label to display a preview of the conversation's content.
    private var previewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    /// A vertical stack view to organize the labels.
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    /// Configures the initial appearance and behavior of the cell.
    ///
    /// - Sets the accessory type to a disclosure indicator.
    /// - Adds a custom selected background view.
    override func setupViews() {
        accessoryType = .disclosureIndicator
        selectedBackgroundView = SelectedView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(senderLabel)
        stackView.addArrangedSubview(subjectLabel)
        stackView.addArrangedSubview(previewLabel)

        contentView.addSubview(stackView)
    }

    /// Applies constraints to the views inside of the cell.
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    /// Configures the cell with the given conversation data.
    ///
    /// - Parameter conversation: A `ConversationPreview` object containing
    ///   the sender, subject, preview, and status information.
    func configure(with conversation: ConversationPreview) {
        senderLabel.text = conversation.customer?.displayName
        subjectLabel.text = conversation.subject
        previewLabel.text = conversation.preview

        // Here we configure the bkcolor
        setBackgroundColor(for: conversation.status)
    }

    /// Updates the cell's background color based on the conversation status.
    ///
    /// - Parameter status: The `ConversationStatus` value representing the conversation's current state.
    private func setBackgroundColor(for status: ConversationStatus) {
        switch status {
        case .active: backgroundColor = .activeCell
        default: backgroundColor = .inactiveCell
        }
    }
}
