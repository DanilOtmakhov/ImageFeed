//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    //MARK: - Public Properties
    
    static let shared = OAuth2Service()
    
    //MARK: - Private Properties
    private var lastCode: String?
    private var task: URLSessionTask?
    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Public Methods
        
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let responseBody):
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    //MARK: - Private Methods
        
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        return URLRequest.makeRequest(
            host: "unsplash.com",
            path: "/oauth/token",
            method: "POST",
            queryItems: [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
        )
    }
}
