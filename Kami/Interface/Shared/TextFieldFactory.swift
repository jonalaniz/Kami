//
//  TextFieldFactory.swift
//  Kami
//
//  Created by Jon Alaniz on 1/1/25.
//

import UIKit

enum TextFieldType {
    case email, normal, password, URL

    func placeholder() -> String {
        switch self {
        case .email:
            return "user@example.com"
        case .normal:
            return ""
        case .password:
            return "Required"
        case .URL:
            return "https://www.example.com"
        }
    }
}

class TextFieldFactory {
    static func textField(type: TextFieldType, placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.returnKeyType = .done

        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default

        switch type {
        case .email:
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
        case .normal:
            textField.textContentType = .name
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .default
        case .password:
            textField.textContentType = .password
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .words
        case .URL:
            textField.textContentType = .URL
            textField.keyboardType = .URL
        }

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))

        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.layoutIfNeeded()

        return textField
    }
}
