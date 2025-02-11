//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 29.12.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var imageView: UIImageView = {
        $0.image = UIImage(named: "0")
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var scrollView: UIScrollView = {
        $0.delegate = self
        $0.contentMode = .scaleAspectFill
        $0.minimumZoomScale = 0.1
        $0.maximumZoomScale = 1.25
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    private lazy var backButton: UIButton = {
        $0.setImage(UIImage(named: "backward_white"), for: .normal)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var shareButton: UIButton = {
        $0.setImage(UIImage(named: "share"), for: .normal)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func centerImageInScrollView() {
        let boundsSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let offsetX = max((boundsSize.width - contentSize.width) * 0.5, 0)
        let offsetY = max((boundsSize.height - contentSize.height) * 0.5, 0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }

    // MARK: - Actions
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton() {
        guard let image else { return }
        let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityController, animated: true)
    }
}

// MARK: - Setup

extension SingleImageViewController {
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        
        [scrollView, backButton, shareButton].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            backButton.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 51),
            shareButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageInScrollView()
    }
}
