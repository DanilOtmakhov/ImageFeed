//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 28.12.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var profileImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var nameLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        $0.textColor = .clear
        return $0
    }(UILabel())
    
    private lazy var loginLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .clear
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .clear
        return $0
    }(UILabel())
    
    private lazy var logoutButton: UIButton = {
        $0.setImage(UIImage(named: "logout"), for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Private Properties
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    private var isLoading = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNotificationObserver()
        
        guard let profile = ProfileService.shared.profile else { return }
        updateProfileDetails(profile: profile)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isLoading {
            setupAnimations()
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
}

// MARK: - Setup

private extension ProfileViewController {
    func setupViewController() {
        view.backgroundColor = .ypBlack
        
        [profileImageView, nameLabel, loginLabel, descriptionLabel, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 48),
            logoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setupNotificationObserver() {
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
    
    func setupAnimations() {
        view.layoutIfNeeded()
        
        [profileImageView, nameLabel, loginLabel, descriptionLabel].forEach {
            $0.addGradientWithAnimation(cornerRadius: $0.frame.height / 2)
        }
    }
    
}

// MARK: - Internal Methods

extension ProfileViewController {
    
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "userpick_no_photo")) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let imageResult):
                    self.isLoading = false
                    self.updateViewForProfilePhotoLoad(imageResult.image)
                case .failure:
                    break
                }
            }
    }
    
}

// MARK: - Private Methods

private extension ProfileViewController {
    
    func switchToSplashViewController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
    }
    
    func updateViewForProfilePhotoLoad(_ image: UIImage) {
        [profileImageView, nameLabel, loginLabel, descriptionLabel].forEach { $0.removeAllGradients() }
        logoutButton.isHidden = false
        profileImageView.setImageWithFade(image, duration: 1)
        nameLabel.setTextColorWithFade(to: .ypWhite, duration: 1)
        loginLabel.setTextColorWithFade(to: .ypGray, duration: 1)
        descriptionLabel.setTextColorWithFade(to: .ypWhite, duration: 1)
    }
    
}

// MARK: - Actions

extension ProfileViewController {
    
    @objc private func didTapLogoutButton() {
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttons: [
                (title: "Да", handler: { [weak self] in
                    guard let self else { return }
                    ProfileLogoutService.shared.logout()
                    self.switchToSplashViewController()
                }),
                (title: "Нет", handler: nil)
            ]
        )
        alertPresenter.show(alertModel: alertModel)
    }
    
}
