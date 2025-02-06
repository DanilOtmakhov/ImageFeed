//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 03.02.2025.
//

import Foundation

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    
    //MARK: - Public Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK: - Private Properties
    
    private(set) var profileImageURL: String?
    private var task: URLSessionTask?
    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Public Properties
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard
            let request = makeProfileImageURLRequest(username)
        else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                let profileImageURL = userResult.profileImage.small
                self.profileImageURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self)
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    //MARK: - Private Properties
    
    private func makeProfileImageURLRequest(_ username: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/users/\(username)"
        
        guard
            let url = urlComponents.url,
            let token = OAuth2TokenStorage().token
        else {
            assertionFailure("Unable to construct profileRequest")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
