//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 20.02.2025.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Public Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
            
        guard
            let request = makePhotosNextPageURLRequest(nextPage)
        else {
            let error = NetworkError.invalidRequest
            error.log(object: self)
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], any Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                let photos = photoResult.map { Photo(from: $0) }
                self.photos.append(contentsOf: photos)
                self.lastLoadedPage = nextPage
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
            case .failure(let error):
                error.log(object: self)
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makePhotosNextPageURLRequest(_ page: Int) -> URLRequest? {
        guard let token = OAuth2TokenStorage().token else {
            assertionFailure("Missing auth token")
            return nil
        }
        
        return URLRequest.makeRequest(
            host: "api.unsplash.com",
            path: "/photos",
            queryItems: [URLQueryItem(name: "page", value: String(page))],
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
}
