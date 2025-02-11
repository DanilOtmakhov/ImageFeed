//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 26.12.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        $0.backgroundColor = .ypBlack
        $0.dataSource = self
        $0.delegate = self
        $0.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        $0.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    // MARK: - Private Properties
    
    private let photosNames: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private let currentDate = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Private Methods
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosNames[indexPath.row]) else { return }
        cell.cellImageView.image = image
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        cell.likeButton.setImage(indexPath.row % 2 == 0 ? UIImage(named: "like_on") : UIImage(named: "like_off"), for: .normal)
    }

}

// MARK: - Setup

extension ImagesListViewController {
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.image = UIImage(named: photosNames[indexPath.row])
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return 0
        }
        
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        let imageViewWidth = view.bounds.width - 32
        
        return imageHeight * (imageViewWidth / imageWidth)
    }
}

