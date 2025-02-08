//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private let logoImageView: UIImageView = {
        $0.image = UIImage(named: "splash_screen_logo")
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    private lazy var oAuth2TokenStorage = OAuth2TokenStorage()
    private lazy var isAuthenticationCompleted = oAuth2TokenStorage.token != nil
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)
    
    //MARK: - Lifecycle
    
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
            guard
                let viewController = UIStoryboard(
                    name: "Main",
                    bundle: nil
                ).instantiateViewController(
                    withIdentifier: "AuthViewController"
                )
                    as? AuthViewController
            else {
                assertionFailure("AuthViewController not found")
                return
            }
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    //MARK: - Private Methods
    
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarController")
        window.rootViewController = tabBarController
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oAuth2TokenStorage.token else { return }
        fetchProfile(token)
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
                    buttonText: "Ок",
                    completion: nil
                )
                alertPresenter.show(alertModel: alertModel)
            }
        }
    }
}
