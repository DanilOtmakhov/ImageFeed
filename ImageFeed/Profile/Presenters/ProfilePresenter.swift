//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 15.03.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProfileImage()
    func userDidRequestLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        guard let profile = ProfileService.shared.profile else { return }
        setupNotificationObserver()
        view?.setProfileDetails(profile: profile)
        updateProfileImage()
    }
    
    func updateProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setProfileImage(with: url)
    }
    
    func userDidRequestLogout() {
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttons: [
                (title: "Да", handler: { [weak self] in
                    guard let self else { return }
                    ProfileLogoutService.shared.logout()
                    view?.switchToSplashViewController()
                }),
                (title: "Нет", handler: nil)
            ]
        )
        view?.show(alertModel)
    }
    
    private func setupNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateProfileImage()
            }
    }
    
}
