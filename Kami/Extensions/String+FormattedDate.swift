//
//  String+FormattedDate.swift
//  Kami
//
//  Created by Jon Alaniz on 12/24/24.
//

import Foundation

extension String {
    /// Converts an ISO 8601 date string into a formatted date string.
    ///
    /// This method attempts to parse the string as an ISO 8601 date and converts it into a
    /// more human-readable format. If the string cannot be parsed as a valid date,
    /// the method returns an empty string.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let isoDate = "2024-12-24T18:30:00Z"
    /// let formattedDate = isoDate.formattedDate()
    /// print(formattedDate) // Output: "Dec 24"
    /// ```
    ///
    /// - Returns: A `String` representing the formatted date in the "MMM d" format,
    ///            or an empty string if the conversion fails.
    func formattedDate() -> String {
        // Create an ISO8601DateFormatter to parse the string into a Date object
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        // Try to parse the string as an ISO8601 date else return an empty string
        guard let date = isoFormatter.date(from: self)
        else { return "" }

        // Create a DateFormatter to format the Data into "MMM d" format
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        // Convert the Date into the desired string format return it
        return formatter.string(from: date)
    }
}
