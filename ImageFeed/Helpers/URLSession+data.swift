//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

enum NetworkError: Error {
    
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    
    var localizedDescription: String {
        switch self {
        case .httpStatusCode(let statusCode):
            return "HTTP request failed with status code: \(statusCode)"
        case .urlRequestError(let error):
            return "URL request failed with error: \(error.localizedDescription)"
        case .urlSessionError:
            return "URL session error occurred"
        }
    }
}

extension URLSession {
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
                    print(NetworkError.httpStatusCode(statusCode).localizedDescription)
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error).localizedDescription)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print(NetworkError.urlSessionError.localizedDescription)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
}
