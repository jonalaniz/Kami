//
//  InputCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/31/24.
//

import UIKit

class InputCell: BaseTableViewCell {
    /// The unique reuse identifier for this cell type.
    static let reuiseIdentifier = "InputCell"

    /// The `UITextField` displayed in the cell.
    ///
    /// - The `textField` is initialized externally and fully customizable.
    var textField: UITextField!

    /// Initializes an `InputCell` with a provided `UITextField`.
    ///
    /// - Parameters:
    ///   - textField: The `UITextField` to embed within the cell.
    ///   This allowscustomization of the text field outside of the class.
    init(textField: UITextField) {
        self.textField = textField
        super.init(style: .default, reuseIdentifier: InputCell.reuiseIdentifier)
    }

    /// Initializes a `InputCell` from a storyboard or nib.
    ///
    /// This initializer is not implemented and will throw a fatal error if called.
    required init(coder: NSCoder) {
        fatalError(Constants.errorInitCoder)
    }

    /// Sets up the views within the cell.
    ///
    /// This method:
    /// - Disables the selection style for the cell.
    /// - Sets the background color to `.inactiveCell`.
    /// - Adds the `textField` as a subview and prepares it for Auto Layout.
    override func setupViews() {
        self.selectionStyle = .none
        backgroundColor = .inactiveCell
        textField.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textField)
    }

    /// Sets up the constraints for the `textField` using Auto Layout.
    ///
    /// The `textField` is pinned to all edges of the cell's content view with no padding.
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
