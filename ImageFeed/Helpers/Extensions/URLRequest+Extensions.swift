//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import Foundation

extension URLRequest {
    static func makeRequest(
        scheme: String = "https",
        host: String,
        path: String,
        method: String = "GET",
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            assertionFailure("Unable to construct URLRequest for \(host)\(path)")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

