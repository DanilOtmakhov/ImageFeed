//
// UIView+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 27.12.2024.
//

import UIKit

extension UIView {
    
    func addGradient(
        colors: [UIColor] = [.clear, .ypGradient],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
    ) {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer.createGradient(
            frame: bounds,
            colors: colors.map { $0.cgColor
            },
            locations: nil,
            startPoint: startPoint,
            endPoint: endPoint,
            cornerRadius: 0)
        
        layer.addSublayer(gradientLayer)
    }
    
    func addGradientWithAnimation(
        colors: [UIColor] = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1),
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1),
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1)
        ],
        locations: [NSNumber]? = [0, 0.1, 0.3],
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
        cornerRadius: CGFloat = 0,
        animationDuration: CFTimeInterval = 1.0,
        animationRepeatCount: Float = .infinity
    ) {
        let (gradientLayer, animation) = CAGradientLayer.createGradientWithAnimation(
            frame: bounds,
            colors: colors.map { $0.cgColor },
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            cornerRadius: cornerRadius,
            animationDuration: animationDuration,
            animationRepeatCount: animationRepeatCount
        )
        
        layer.addSublayer(gradientLayer)
        
        gradientLayer.add(animation, forKey: "locationsChange")
    }
    
    func removeAllGradients(withDuration duration: CFTimeInterval = 0.3) {
        layer.sublayers?.forEach { sublayer in
            if let gradientLayer = sublayer as? CAGradientLayer {
                let fadeOut = CABasicAnimation(keyPath: "opacity")
                fadeOut.fromValue = gradientLayer.opacity
                fadeOut.toValue = 0
                fadeOut.duration = duration
                fadeOut.fillMode = .forwards
                fadeOut.isRemovedOnCompletion = false
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    gradientLayer.removeFromSuperlayer()
                }
                gradientLayer.add(fadeOut, forKey: "fadeOut")
                CATransaction.commit()
            }
        }
    }
    
}
