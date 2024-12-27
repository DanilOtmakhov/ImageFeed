//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 26.12.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {

    //MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Private Properties
    private let photosNames: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
    //MARK: - Private Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return
        }
        cell.cellImageView.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(indexPath.row % 2 == 0 ? UIImage(named: "like_on") : UIImage(named: "like_off"), for: .normal)
    }

}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
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
