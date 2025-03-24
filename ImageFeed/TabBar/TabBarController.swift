//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 07.02.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTabBarAppearance()
    }
}

// MARK: - Setup

extension TabBarController {
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter()
        
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListPresenter
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_main_active"),
            selectedImage: nil
        )
        
        let profileViewPresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
           
       self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    private func setupTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let standardAppearance = UITabBarAppearance()
            standardAppearance.configureWithOpaqueBackground()
            standardAppearance.backgroundColor = .ypBlack
            standardAppearance.shadowColor = .clear
            
            let scrollEdgeAppearance = UITabBarAppearance()
            scrollEdgeAppearance.configureWithOpaqueBackground()
            scrollEdgeAppearance.backgroundColor = .ypBlack
            scrollEdgeAppearance.shadowColor = .clear
            
            tabBar.standardAppearance = standardAppearance
            tabBar.scrollEdgeAppearance = scrollEdgeAppearance
        } else {
            tabBar.barTintColor = .ypBlack
        }
        
        tabBar.tintColor = .white
    }
}
