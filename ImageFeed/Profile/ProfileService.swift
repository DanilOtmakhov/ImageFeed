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
        if task != nil {
            task?.cancel()
        }
        
        guard
            let request = makeProfileRequest(token)
        else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let profileResult = try self.decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(from: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                } catch {
                    print("Failed to decode Profile response: \(error.localizedDescription)")
                    completion(.failure(error))
                }
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
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        guard
            let url = urlComponents.url
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
