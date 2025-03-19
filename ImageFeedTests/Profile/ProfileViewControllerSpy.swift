//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 19.03.2025.
//

import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var profile: Profile?
    var profileImageURL: URL?
    var showCalled = false
    var switchToSplashViewControllerCalled = false
    
    var presenter: ProfilePresenterProtocol?
    
    func setProfileDetails(profile: Profile) {
        self.profile = profile
    }
    
    func setProfileImage(with url: URL) {
        profileImageURL = url
    }
    
    func show(_ alertModel: AlertModel) {
        showCalled = true
    }
    
    func switchToSplashViewController() {
        switchToSplashViewControllerCalled = true
    }
    
}
