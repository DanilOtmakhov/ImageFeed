//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 27.12.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Views
    
    lazy var cellImageView: UIImageView = {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var dateLabel: UILabel = {
        $0.text = "27 августа 2022"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var likeButton: UIButton = {
        $0.setImage(UIImage(named: "like_on"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var gradientView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension ImagesListCell {
    private func setupCell() {
        self.backgroundColor = .ypBlack
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
        [cellImageView, likeButton, gradientView].forEach {
            self.addSubview($0)
        }
        
        gradientView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            
            gradientView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 4)
        ])
    }
    
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
