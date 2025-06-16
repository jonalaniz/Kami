//
//  User.swift
//  Scouter
//
//  Created by Jon Alaniz on 6/29/24.
//

import Foundation

// swiftlint:disable identifier_name
struct Users: Codable {
    let embeddedUsers: EmbeddedUsers
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embeddedUsers = "_embedded"
        case page
    }

    init(embeddedUsers: EmbeddedUsers, page: Page) {
        self.embeddedUsers = embeddedUsers
        self.page = page
    }
}

struct EmbeddedUsers: Codable {
    let users: [User]
}

struct User: Codable {
    let id: Int
    let role: String?
    let firstName: String?
    let lastName: String?
    let photoUrl: String
    let email: String

    func name() -> String {
        var name = ""
        if let firstName = firstName {
            name += firstName
        }

        if let lastName = lastName {
            name += " " + lastName
        }

        if name == "" {
            name += email
        }

        return name
    }
}
