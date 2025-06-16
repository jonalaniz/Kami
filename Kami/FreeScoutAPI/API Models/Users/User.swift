//
//  User.swift
//  Scouter
//
//  Created by Jon Alaniz on 6/29/24.
//

import Foundation

// swiftlint:disable identifier_name
struct UsersContainer: Codable {
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
    let firstName: String?
    let lastName: String?
    let email: String
    let role: Role
    let alternateEmails: String?
    let jobTitle: String?
    let phone: String?
    let timezone: String
    let photoUrl: String?
    let language: String?
    let createdAt: String
    let updatedAt: String?

    var displayName: String {
        let fullName = [firstName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return fullName.isEmpty ? email : fullName
    }
}
