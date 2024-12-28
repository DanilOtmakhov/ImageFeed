//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 27.12.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    //MARK: - IB Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let colors: [UIColor] = [.clear, .ypGradient]
        gradientView.addGradient(
            for: gradientView,
            colors: colors,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0)
        )
    }
}
