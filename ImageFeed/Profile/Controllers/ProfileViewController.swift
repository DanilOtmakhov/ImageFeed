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
        $0.textColor = .ypWhite
        return $0
    }(UILabel())
    
    private lazy var loginLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .ypGray
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .ypWhite
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
    private var animationLayers = Set<CALayer>()
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
            setupGradients()
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
    
    func setupGradients() {
        view.layoutIfNeeded()
        
        let profileImageViewGradient = CAGradientLayer.createGradient(
            frame: profileImageView.bounds,
            cornerRadius: profileImageView.frame.height / 2
        )
        
        let nameLabelGradient = CAGradientLayer.createGradient(
            frame: nameLabel.bounds,
            cornerRadius: nameLabel.frame.height / 2
        )
        
        let loginLabelGradient = CAGradientLayer.createGradient(
            frame: loginLabel.bounds,
            cornerRadius: loginLabel.frame.height / 2
        )
        
        let descriptionLabelGradient = CAGradientLayer.createGradient(
            frame: descriptionLabel.bounds,
            cornerRadius: descriptionLabel.frame.height / 2
        )
        
        [profileImageViewGradient, nameLabelGradient, loginLabelGradient, descriptionLabelGradient].forEach { animationLayers.insert($0) }
        
        profileImageView.layer.addSublayer(profileImageViewGradient)
        nameLabel.layer.addSublayer(nameLabelGradient)
        loginLabel.layer.addSublayer(loginLabelGradient)
        descriptionLabel.layer.addSublayer(descriptionLabelGradient)
        
        setupAnimations()
    }
    
    func setupAnimations() {
        guard !animationLayers.isEmpty else { return }
        
        let gradientChangeAnimation = CAGradientLayer.createGradientAnimation()
        animationLayers.forEach { $0.add(gradientChangeAnimation, forKey: "locationsChange") }
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
                    self.profileImageView.image = imageResult.image
                    self.isLoading = false
                    self.animationLayers.forEach { $0.removeFromSuperlayer() }
                    self.animationLayers.removeAll()
                    self.logoutButton.isHidden = false
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
