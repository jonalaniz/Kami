//
//  URL+AppendingPathCompontentSafely.swift
//  Scouter
//
//  Created by Jon Alaniz on 12/2/24.
//

import Foundation

/// An extension of `URL` that provides a safer method for appending path components that
/// works with the FreeScoutAPI
extension URL {
    /// Appends a path component to the URL, ensuring no redundant slashes are added.
    ///
    /// The method removes any trailing slash from the URL's path before appending the component.
    ///
    /// - Parameter component: The path component to append to the URL.
    /// - Returns: A new `URL` with the specified path component safely appended.
    func appendingPathComponentSafely(_ component: String) -> URL {
        var finalPath = self.path
        if finalPath.hasSuffix("/") {
            finalPath.removeLast()
        }

        return self.appendingPathComponent(component)
    }
}
