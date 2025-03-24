//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 19.03.2025.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func photo(at index: Int) -> Photo?
    func updatePhotos()
    func fetchNextPhotosPageIfNeeded(_ index: Int)
    func changeLikeForPhoto(at index: Int, _ completion: @escaping (Result<Bool , Error>) -> Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Internal Properties
    
    weak var view: ImagesListViewControllerProtocol?
    var photosCount: Int {
        photos.count
    }
    
    // MARK: - Private Properties
    
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    private var imagesListServiceErrorObserver: NSObjectProtocol?
    
}

// MARK: - Internal Methods

extension ImagesListPresenter {
    
    func viewDidLoad() {
        setupNotificationObservers()
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func photo(at index: Int) -> Photo? {
        guard index >= 0 && index < photos.count else {
            return nil
        }
        
        return photos[index]
    }
    
    func updatePhotos() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        
        guard oldCount != newCount else { return }
        view?.updateTableViewAnimated(from: oldCount, to: newCount)
    }
    
    func fetchNextPhotosPageIfNeeded(_ index: Int) {
        guard index + 1 == photosCount else { return }
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func changeLikeForPhoto(at index: Int, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let photo = photo(at: index) else { return }
        
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            
            guard let self else { return }
            switch result {
            case .success:
                self.photos = ImagesListService.shared.photos
                completion(.success(self.photos[index].isLiked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

// MARK: - Private Methods

private extension ImagesListPresenter {
    
    func setupNotificationObservers() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self else { return }
                    self.updatePhotos()
                }
            )
        
        imagesListServiceErrorObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didFailNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self else { return }
                    view?.showSomethingWentWrongError {
                        ImagesListService.shared.fetchPhotosNextPage()
                    }
                }
            )
    }
    
}
