//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 22.01.2025.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
