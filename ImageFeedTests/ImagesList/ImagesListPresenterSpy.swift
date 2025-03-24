//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Danil Otmakhov on 19.03.2025.
//

@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var viewDidLoadCalled = false
    var photosCountCalled = false
    var fetchNextPhotosPageIfNeededCalled = false
    
    var view: ImagesListViewControllerProtocol?
    
    var photosCount: Int = 10
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photo(at index: Int) -> Photo? {
        return nil
    }
    
    func updatePhotos() {
        
    }
    
    func fetchNextPhotosPageIfNeeded(_ index: Int) {
        fetchNextPhotosPageIfNeededCalled = true
    }
    
    func changeLikeForPhoto(at index: Int, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        
    }
    
}
