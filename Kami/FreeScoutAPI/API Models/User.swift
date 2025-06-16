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
    let photoUrl: String?
    let email: String

    var displayName: String {
        let fullName = [firstName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return fullName.isEmpty ? email : fullName
    }
}
