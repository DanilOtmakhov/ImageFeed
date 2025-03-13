//
//  UIImageView+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 13.03.2025.
//

import UIKit

extension UIImageView {
    
    func setImageWithFade(_ image: UIImage?, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
    
}
