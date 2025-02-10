//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 07.02.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
            
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_main_active"),
            selectedImage: nil
        )
            
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
           
       self.viewControllers = [imagesListViewController, profileViewController]
    }
}
