//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 20.02.2025.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Internal Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let didFailNotification = Notification.Name(rawValue: "ImageListServiceDidFail")
    
    // MARK: - Private Properties
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
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
                do {
                    let photos = try photoResult.map { try Photo(from: $0) }
                    let newPhotos = photos.filter { photo in
                        !self.photos.contains(where: { $0.id == photo.id })
                    }
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self
                        )
                } catch {
                    self.notifyPhotoLoadingError(error)
                }
            case .failure(let error):
                self.notifyPhotoLoadingError(error)
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard
            let request = makeChangeLikeRequest(photoId: photoId, with: isLike ? .post : .delete)
        else {
            let error = NetworkError.invalidRequest
            error.log(object: self)
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let likeResult):
                let photoResult = likeResult.photo
                guard let index = self.photos.firstIndex(where: { $0.id == photoResult.id }) else { return }
                
                let photo = self.photos[index]
                let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: photoResult.likedByUser
                )
                self.photos[index] = newPhoto
                completion(.success(()))
            case .failure(let error):
                error.log(object: self)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func resetPhotos() {
        photos = []
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
    
    private func makeChangeLikeRequest(photoId: String, with method: URLRequest.HTTPMethod) -> URLRequest? {
        guard let token = OAuth2TokenStorage().token else {
            assertionFailure("Missing auth token")
            return nil
        }
        
        return URLRequest.makeRequest(
            host: "api.unsplash.com",
            path: "/photos/\(photoId)/like",
            method: method,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
    
    private func notifyPhotoLoadingError(_ error: Error) {
        error.log(object: self)
        NotificationCenter.default.post(
            name: ImagesListService.didFailNotification,
            object: self,
            userInfo: ["error": error]
        )
    }
}
