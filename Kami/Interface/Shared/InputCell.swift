//
//  InputCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/31/24.
//

import UIKit

class InputCell: BaseTableViewCell {
    static let reuiseIdentifier = "InputCell"
    var textField: UITextField!

    init(textField: UITextField) {
        self.textField = textField
        super.init(style: .default, reuseIdentifier: InputCell.reuiseIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        self.selectionStyle = .none
        backgroundColor = .inactiveCell
        textField.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textField)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

