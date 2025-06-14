//
//  Configuration.swift
//  Kami
//
//  Created by Jon Alaniz on 6/14/25.
//

import UIKit

// TODO: Add configuration of any sort
struct Configuration: Codable {
    let sampleData: String

    static let defaults = Configuration(sampleData: "SampleData")
}
