//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var logoImageView: UIImageView = {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    // MARK: - Private Properties
    
    private lazy var oAuth2TokenStorage = OAuth2TokenStorage()
    private lazy var isAuthenticationCompleted = oAuth2TokenStorage.token != nil
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isAuthenticationCompleted {
            guard let token = oAuth2TokenStorage.token else { return }
            fetchProfile(token)
        } else {
            showAuthViewController()
        }
    }
    
    // MARK: - Private Methods
    
    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

// MARK: - Setup

extension SplashViewController {
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        isAuthenticationCompleted = true
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonText: "Ок") { [weak self] in
                        guard let self else { return }
                        self.showAuthViewController()
                    }
                alertPresenter.show(alertModel: alertModel)
            }
        }
    }
}
