//
//  String+FormattedDate.swift
//  Kami
//
//  Created by Jon Alaniz on 12/24/24.
//

import Foundation

extension String {
    func formattedDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        guard let date = isoFormatter.date(from: self)
        else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        return formatter.string(from: date)
    }
}
