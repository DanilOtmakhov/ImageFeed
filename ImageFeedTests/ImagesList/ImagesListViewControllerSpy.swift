//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Danil Otmakhov on 19.03.2025.
//

@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var updateTableViewAnimatedCalled = false
    
    var presenter: ImagesListPresenterProtocol?
    
    func updateTableViewAnimated(from: Int, to: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func showSomethingWentWrongError(_ handler: (() -> Void)?) {
        
    }
    
}
