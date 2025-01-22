//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private lazy var isAuthenticationCompleted = oAuth2TokenStorage.token != nil
    private let showAuthViewControllerSegueIdentifier = "ShowAuthViewController"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isAuthenticationCompleted {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthViewControllerSegueIdentifier, sender: nil)
        }
    }
    
    //MARK: - Private Methods
    
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

extension SplashScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthViewControllerSegueIdentifier {
            guard let viewController = segue.destination as? AuthViewController else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashScreenViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        switchToTabBarController()
    }
}
