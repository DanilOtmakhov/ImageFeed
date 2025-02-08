//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

enum NetworkError: Error {
    
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .httpStatusCode(let statusCode):
            return "HTTP request failed with status code: \(statusCode)"
        case .urlRequestError(let error):
            return "URL request failed with error: \(error.localizedDescription)"
        case .urlSessionError:
            return "URL session error occurred"
        case .invalidRequest:
            return "The request is invalid"
        case .decodingError:
            return "Failed to decode the response from server"
        }
    }
}

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
    
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
}
