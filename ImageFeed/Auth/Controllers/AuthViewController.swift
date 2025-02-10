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
    
    // MARK: - Views
    
    private lazy var logoImageView: UIImageView = {
        $0.image = UIImage(named: "unsplash_logo")
        return $0
    }(UIImageView())
    
    private lazy var loginButton: UIButton = {
        $0.setTitle("Войти", for: .normal)
        $0.setTitleColor(.ypBlack, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Public Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    private lazy var oAuth2TokenStorage = OAuth2TokenStorage()
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Actions
    
    @objc private func didTapLoginButton() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true)
    }
}

// MARK: - Setup

extension AuthViewController {
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        
        [logoImageView, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 236),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - WebViewViewControllerDelegate

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
