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
    
    //MARK: - Private Properties
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Public Methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard
            let request = makeProfileRequest(token)
        else {
            //print("[ProfileService]: Error: Failed to request for token \(token)")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(from: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    //MARK: - Private Methods
    
    private func makeProfileRequest(_ token: String) -> URLRequest? {
        return URLRequest.makeRequest(
            host: "api.unsplash.com",
            path: "/me",
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
}
