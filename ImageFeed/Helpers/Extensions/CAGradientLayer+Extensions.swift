//
//  CAGradientLayer+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 10.03.2025.
//

import UIKit

extension CAGradientLayer {
    
    static func createGradient(
        frame: CGRect,
        colors: [CGColor] = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ],
        locations: [NSNumber]? = [0, 0.1, 0.3],
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
        cornerRadius: CGFloat = 0
    ) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        
        return gradient
    }
    
    static func createGradientAnimation(
        duration: CFTimeInterval = 1.0,
        repeatCount: Float = .infinity,
        fromValue: [NSNumber] = [0, 0.1, 0.3],
        toValue: [NSNumber] = [0, 0.8, 1]
    ) -> CABasicAnimation {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = duration
        gradientChangeAnimation.repeatCount = repeatCount
        gradientChangeAnimation.fromValue = fromValue
        gradientChangeAnimation.toValue = toValue
        
        return gradientChangeAnimation
    }
    
}
