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
        colors: [CGColor],
        locations: [NSNumber]?,
        startPoint: CGPoint,
        endPoint: CGPoint,
        cornerRadius: CGFloat
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
        duration: CFTimeInterval,
        repeatCount: Float,
        fromValue: [NSNumber],
        toValue: [NSNumber]
    ) -> CABasicAnimation {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = duration
        gradientChangeAnimation.repeatCount = repeatCount
        gradientChangeAnimation.fromValue = fromValue
        gradientChangeAnimation.toValue = toValue
        
        return gradientChangeAnimation
    }
    
    static func createGradientWithAnimation(
        frame: CGRect,
        colors: [CGColor],
        locations: [NSNumber]?,
        startPoint: CGPoint,
        endPoint: CGPoint,
        cornerRadius: CGFloat,
        animationDuration: CFTimeInterval,
        animationRepeatCount: Float
    ) -> (gradientLayer: CAGradientLayer, animation: CABasicAnimation) {
        
        let gradient = createGradient(
            frame: frame,
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            cornerRadius: cornerRadius
        )
        
        let animation = createGradientAnimation(
            duration: animationDuration,
            repeatCount: animationRepeatCount,
            fromValue: locations ?? [0, 0.1, 0.3],
            toValue: [0, 0.8, 1]
        )
        
        return (gradient, animation)
    }
    
}
