//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 27.12.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    private enum CellImageState {
        case loading
        case error
        case finished(UIImage)
    }
    
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
        $0.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var dateLabelGradientView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var gradientOverlayView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())
    
    // MARK: - Internal Properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Private Properties
    
    private var imageState: CellImageState = .loading
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabelGradientView.addGradient()
        updateViewForStateChange()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        gradientOverlayView.removeAllGradients()
    }
    
}

// MARK: - Setup

extension ImagesListCell {
    
    private func setupCell() {
        self.backgroundColor = .ypBlack
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
        [cellImageView, likeButton, dateLabelGradientView, gradientOverlayView].forEach {
            self.addSubview($0)
        }
        
        dateLabelGradientView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            
            dateLabelGradientView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            dateLabelGradientView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            dateLabelGradientView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            dateLabelGradientView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateLabelGradientView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabelGradientView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: dateLabelGradientView.bottomAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: dateLabelGradientView.topAnchor, constant: 4),
            
            gradientOverlayView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            gradientOverlayView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            gradientOverlayView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            gradientOverlayView.topAnchor.constraint(equalTo: cellImageView.topAnchor)
        ])
    }
    
}

// MARK: - Internal Methods

extension ImagesListCell {
    
    func config(with photo: Photo) {
        let placeholder = generatePlaceholderImage(bounds.size)
        guard let url = URL(string: photo.thumbImageURL) else { return }
        
        imageState = .loading
        
        cellImageView.kf.indicatorType = .activity
        cellImageView.kf.setImage(
            with: url,
            placeholder: placeholder) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let imageResult):
                    self.imageState = .finished(imageResult.image)
                case .failure:
                    self.imageState = .error
                }
            }
        dateLabel.text = photo.createdAt?.dateString
        setIsLiked(photo.isLiked)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(isLiked ? UIImage(named: "like_on") : UIImage(named: "like_off"), for: .normal)
    }
    
}

// MARK: - Private Methods

private extension ImagesListCell {
    
    func generatePlaceholderImage(_ size: CGSize) -> UIImage {
        let icon = UIImage(named: "placeholder")
        let backgroundColor: UIColor = .ypWhiteAlpha50
        
        return UIGraphicsImageRenderer(size: size).image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            guard let icon else { return }
            let iconSize = CGSize(width: size.width * 0.5,
                                  height: size.height * 0.5)
            let iconOrigin = CGPoint(x: (size.width - iconSize.width) / 2,
                                     y: (size.height - iconSize.height) / 2)
            icon.draw(in: CGRect(origin: iconOrigin, size: iconSize))
        }
    }
    
    func updateViewForStateChange() {
        switch imageState {
        case .loading:
            gradientOverlayView.addGradientWithAnimation(cornerRadius: cellImageView.layer.cornerRadius)
        case .finished:
            gradientOverlayView.removeAllGradients()
        case .error:
            gradientOverlayView.removeAllGradients()
            // TODO: error to vc
        }
    }
    
}

// MARK: - Actions

private extension ImagesListCell {
    
    @objc func didTapLikeButton() {
        delegate?.imageListCellDidTapLike(self)
    }
    
}
