//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Danil Otmakhov on 19.03.2025.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testWillDisplayCell() {
        // Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        let numberOfRows = viewController.tableView.dataSource?.tableView(
            viewController.tableView,
            numberOfRowsInSection: 0
        )
        
        // Then
        XCTAssertEqual(numberOfRows, 10)
    }
    
}
