//
//  UILabel+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 13.03.2025.
//

import UIKit

extension UILabel {
    
    func setTextColorWithFade(to color: UIColor, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.textColor = color
        }, completion: nil)
    }
    
}
