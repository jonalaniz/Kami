//
//  TextFieldFactory.swift
//  Kami
//
//  Created by Jon Alaniz on 1/1/25.
//

import UIKit

/// A utility class for creating and configuring `UITextField` instances based on specified types.
///
/// The `TextFieldFactory` simplifies the creation of text fields with standardized configurations and padding.
class TextFieldFactory {
    /// Creates a `UITextField` configured for a specific type and placeholder text.
    ///
    /// The method configures the text field's content type, keyboard type, and other settings based on the
    /// `TextFieldType` provided.
    ///
    /// - Parameters:
    ///   - type: The type of text field to create, specified using the `TextFieldType` enum.
    ///   - placeholder: The placeholder text to display in the text field.
    /// - Returns: A configured `UITextField` instance.
    static func textField(type: TextFieldType, placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.returnKeyType = .done

        // Default settings
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default

        // Type-specific configurations
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

        // Add padding to the left side of the text field
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 15,
                                               height: textField.frame.height)
        )
        textField.leftView = paddingView
        textField.leftViewMode = .always

        // Additional styling
        textField.borderStyle = .none
        textField.layoutIfNeeded()

        return textField
    }
}
