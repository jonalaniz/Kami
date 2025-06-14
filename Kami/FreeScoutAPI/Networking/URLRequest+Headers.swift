//
//  URLRequest+Headers.swift
//  Scouter
//
//  Created by Jon Alaniz on 9/1/24.
//

import Foundation

extension URLRequest {
    mutating func addHeaders(from headers: [String: String]? = nil) {
        self.addDefaultHeaders()

        if let headers = headers {
            headers.forEach { self.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
    }
    
    mutating func addDefaultHeaders() {
        self.addValue(
            HeaderKeyValue.jsonCharset.rawValue,
            forHTTPHeaderField: HeaderKeyValue.accept.rawValue
        )
        
        self.addValue(
            HeaderKeyValue.applicationJSON.rawValue,
            forHTTPHeaderField: HeaderKeyValue.contentType.rawValue
        )
    }
}
