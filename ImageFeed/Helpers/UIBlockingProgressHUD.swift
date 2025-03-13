//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 31.01.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    // MARK: - Private Properties
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    // MARK: - Internal Methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
