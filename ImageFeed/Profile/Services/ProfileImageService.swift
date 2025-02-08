//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 03.02.2025.
//

import Foundation

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
    
    //MARK: - Public Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard
            let request = makeProfileImageURLRequest(username)
        else {
            let error = NetworkError.invalidRequest
            error.log(object: self)
            completion(.failure(error))
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
                error.log(object: self)
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    //MARK: - Private Methods
    
    private func makeProfileImageURLRequest(_ username: String) -> URLRequest? {
        guard let token = OAuth2TokenStorage().token else {
            assertionFailure("Missing auth token")
            return nil
        }

        return URLRequest.makeRequest(
            host: "api.unsplash.com",
            path: "/users/\(username)",
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
}
