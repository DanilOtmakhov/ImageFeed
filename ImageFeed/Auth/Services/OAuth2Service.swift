//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Internal Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private var lastCode: String?
    private var task: URLSessionTask?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Internal Methods
        
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            let error = NetworkError.invalidRequest
            error.log(object: self)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let responseBody):
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                error.log(object: self)
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
        
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        URLRequest.makeRequest(
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
