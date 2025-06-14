//
//  Secret.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import Foundation

/// A model representing the secure credentials required for authenticated API access.
///
/// Encapsulates the information necessary to connect to a remote service,
/// including the base URL of the API and an associated access key or token.
struct Secret: Codable {
    /// The base URL of the remote API endpoint.
    let url: URL

    /// The API key or token used for authenticating requests to the service.
    let key: String
}
