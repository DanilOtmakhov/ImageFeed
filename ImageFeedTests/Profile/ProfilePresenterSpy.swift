//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 19.03.2025.
//

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var viewDidLoadCalled = false
    
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfileImage() {
        
    }
    
    func userDidRequestLogout() {
        
    }
    
}
