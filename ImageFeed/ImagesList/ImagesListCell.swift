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
    
    // MARK: - Private Properties
    
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"

}
