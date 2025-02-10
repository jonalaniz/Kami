//
//  TextFieldType.swift
//  Kami
//
//  Created by Jon Alaniz on 1/14/25.
//

import Foundation

/// Represents the different types of text fields that can be created.
enum TextFieldType {
    case email
    case normal
    case password
    case URL

    /// Provides a default placeholder string for each `TextFieldType`.
    ///
    /// - Returns: A string to be used as the placeholder for the text field.
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
