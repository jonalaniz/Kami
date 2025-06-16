//
//  FreeScoutAPIErrorResponse.swift
//  Kami
//
//  Created by Jon Alaniz on 6/15/25.
//

import Foundation

struct FreeScoutAPIErrorResponse {
    let message: String
    let errorCode: String
    let embedded: FreeScoutAPIEmbeddedErrors
}

struct FreeScoutAPIEmbeddedErrors {
    let errors: [FreeScoutAPIError]

    struct FreeScoutAPIError {
        let path: String
        let message: String
        let rejectedValue: String?
        let source: String
    }
}
