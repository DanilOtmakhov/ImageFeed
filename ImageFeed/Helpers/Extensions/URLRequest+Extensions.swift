//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import Foundation

extension URLRequest {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    static func makeRequest(
        scheme: String = "https",
        host: String,
        path: String,
        method: HTTPMethod = .get,
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
        request.httpMethod = method.rawValue
        request.httpBody = body

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
    
}

