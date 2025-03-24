//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Danil Otmakhov on 19.03.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsShow() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.userDidRequestLogout()
        
        // Then
        XCTAssertTrue(viewController.showCalled)
    }
    
    func testSetProfileDetailsPassesCorrectData() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let profile = Profile(username: "danilotmakhov", name: "Danil Otmakhov", login: "@danilotmakhov", bio: "")
        
        // When
        viewController.setProfileDetails(profile: profile)
        
        // Then
        XCTAssertEqual(viewController.profile?.username, profile.username)
        XCTAssertEqual(viewController.profile?.name, profile.name)
        XCTAssertEqual(viewController.profile?.login, profile.login)
        XCTAssertEqual(viewController.profile?.bio, profile.bio)
    }
    
    func testSetProfileImagePassesCorrectURL() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let url = URL(string: "https://example.com/profile.jpg")!
        
        // When
        viewController.setProfileImage(with: url)
        
        // Then
        XCTAssertEqual(viewController.profileImageURL, url)
    }
    
}
