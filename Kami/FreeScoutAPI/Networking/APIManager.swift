//
//  APIManager.swift
//  Scouter
//
//  Created by Jon Alaniz on 9/1/24.
//

import Foundation

final class APIManager: Managable {
    // MARK: - Singleton

    static let shared: Managable = APIManager()
    private init() {}

    // MARK: - Properties

    public internal(set) var session = URLSession.shared

    // MARK: - URL Requests
    func request<T>(url: URL,
                    httpMethod: ServiceMethod,
                    body: Data?,
                    headers: [String: String]?
    ) async throws -> T where T: Decodable, T: Encodable {
        let request = buildRequest(
            url: url,
            httpMethod: httpMethod,
            body: body,
            headers: headers
        )
        let (data, response) = try await session.data(for: request)
        return try await handleResponse(data: data, response: response)
    }

    private func buildRequest(
        url: URL,
        httpMethod: ServiceMethod,
        body: Data?,
        headers: [String: String]?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        if let body = body, httpMethod != .get {
            request.httpBody = body
        }

        request.addHeaders(from: headers)

        return request
    }

    private func validateResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIManagerError.conversionFailedToHTTPURLResponse
        }

        let statusCode = httpResponse.statusCode

        // TODO: Check if there are documented status codes and errors to add
        guard (200...299).contains(statusCode) else {
            throw APIManagerError.invalidResponse(statuscode: statusCode)
        }
    }

    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) async throws -> T {
        try validateResponse(data: data, response: response)

        do {
            return try deconde(data)
        } catch {
            print(error)
            throw APIManagerError.serializationFailed(error)
        }
    }

    private func deconde<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
