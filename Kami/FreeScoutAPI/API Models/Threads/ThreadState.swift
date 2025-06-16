//
//  ThreadState.swift
//  Kami
//
//  Created by Jon Alaniz on 6/16/25.
//

import Foundation

enum ThreadState: String, Codable {
    case draft
    case published
    case hidden
    case review
}
