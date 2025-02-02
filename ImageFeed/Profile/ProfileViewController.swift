//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 28.12.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private let profileImageView: UIImageView = {
        $0.image = UIImage(named: "userpick")
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.text = "Екатерина Новикова"
        $0.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        $0.textColor = .ypWhite
        return $0
    }(UILabel())
    
    private let loginLabel: UILabel = {
        $0.text = "@ekaterina_nov"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .ypGray
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.text = "Hello, world!"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .ypWhite
        return $0
    }(UILabel())
    
    private let logoutButton: UIButton = {
        $0.setImage(UIImage(named: "logout"), for: .normal)
        return $0
    }(UIButton())
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    //MARK: - Private Methods
    
    private func setupViewController() {
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
}
