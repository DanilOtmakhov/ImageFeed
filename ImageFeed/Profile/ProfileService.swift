//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 31.01.2025.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    //MARK: - Public Properties
    
    static let shared = ProfileService()
    
    //MARK: - Private Methods
    
    private var task: URLSessionTask?
    private lazy var oAuth2TokenStorage = OAuth2TokenStorage()
    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    //MARK: - Initializer
    
    private init() {}
    
    //MARK: - Public Methods
    
    func makeProfileRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        guard
            let url = urlComponents.url,
            let token = oAuth2TokenStorage.token
        else {
            assertionFailure("Unable to construct profileRequest")
            return nil
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfile(completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard
            let request = makeProfileRequest()
        else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    guard let self else { return }
                    let profileData = try self.decoder.decode(ProfileResult.self, from: data)
                    completion(.success(profileData))
                } catch {
                    print("Failed to decode Profile response: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
}
