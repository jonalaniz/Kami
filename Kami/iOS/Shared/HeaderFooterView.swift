//
//  MailboxHeaderView.swift
//  Kami
//
//  Created by Jon Alaniz on 12/24/24.
//

import UIKit


/// An enum representing the type of the header or footer view.
enum HeaderFooterType {
    case header
    case footer
}

/// A reusable view for displaying headers or footers in a table view or collection view.
///
/// The `HeaderFooterView` class includes a `UILabel` that can be configured with a title and styled
/// based on whether it is used as a header or footer.
class HeaderFooterView: UIView {
    /// The label used to display the header or footer text.
    ///
    /// - By default:
    ///   - It supports multiple lines (`numberOfLines = 0`).
    ///   - It uses the `.iconsMainToolbar` color for text.
    ///   - It uses Auto Layout for positioning.
    let headerLabel = UILabel()

    /// Initializes a new `HeaderFooterView` with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    /// Initializes a `HeaderFooterView` from a storyboard or nib.
    ///
    /// This initializer is not implemented and will throw a fatal error if called.
    required init(coder: NSCoder) {
        fatalError(Constants.errorInitCoder)
    }

    /// Configures the appearance and content of the header or footer view.
    ///
    /// - Parameters:
    ///   - label: The text to display in the header or footer.
    ///   - type: The type of the view, either `.header` or `.footer`. Determines the font style.
    func configure(label: String?, type: HeaderFooterType) {
        headerLabel.text = label

        let font: UIFont

        switch type {
        case .header: font = .preferredFont(forTextStyle: .headline)
        case .footer: font = .preferredFont(forTextStyle: .footnote)
        }

        headerLabel.font = font
    }

    /// Sets up the initial appearance and behavior of the view.
    ///
    /// This method:
    /// - Configures the label for multiline text.
    /// - Sets the text color to `.iconsMainToolbar`.
    /// - Adds the label as a subview.
    private func setupView() {
        headerLabel.numberOfLines = 0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = .iconsMainToolbar

        addSubview(headerLabel)
    }

    /// Sets up the Auto Layout constraints for the label.
    ///
    /// The label is positioned with padding of:
    /// - 16 points from the leading and trailing edges.
    /// - 8 points from the top and bottom edges.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
