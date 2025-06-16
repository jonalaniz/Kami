//
//  Attachment.swift
//  Kami
//
//  Created by Jon Alaniz on 6/16/25.
//

import Foundation

// swiftlint:disable identifier_name
struct EmbeddedAttachments: Codable {
    let attachments: [Attachment]
}

struct Attachment: Codable {
    let id: Int
    let fileName: String
    let fileURL: String
    let mimeType: String
    let size: Int

    enum CodingKeys: String, CodingKey {
        case id, fileName
        case fileURL = "fileUrl"
        case mimeType, size
    }
}
