//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 17.01.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    //MARK: - Public Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Private Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    private lazy var oAuth2TokenStorage = OAuth2TokenStorage()
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)
}

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                self.oAuth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self)
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
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
