//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 26.12.2024.
//

import UIKit
import Kingfisher

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
    
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    private var imagesListServiceErrorObserver: NSObjectProtocol?
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNotificationObserver()
        
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    // MARK: - Private Methods
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.configure(with: photos[indexPath.row]) { [weak self] in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.delegate = self
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        
        guard oldCount != newCount else { return }
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    private func showSomethingWentWrongError(_ handler: (() -> Void)?) {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: nil,
            buttons: [(title: "Ок", handler: handler)]
        )
        alertPresenter.show(alertModel: alertModel)
    }
}

// MARK: - Setup

private extension ImagesListViewController {
    func setupViewController() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self else { return }
                    self.updateTableViewAnimated()
                }
            )
        
        imagesListServiceErrorObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didFailNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self else { return }
                    self.showSomethingWentWrongError {
                        ImagesListService.shared.fetchPhotosNextPage()
                    }
                }
            )
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configureCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.configure(with: photos[indexPath.row])
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageHeight = photo.size.height
        let imageWidth = photo.size.width
        let imageViewWidth = view.bounds.width - 32
        
        return imageHeight * (imageViewWidth / imageWidth)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        ImagesListService.shared.fetchPhotosNextPage()
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            switch result {
            case .success:
                self.photos = ImagesListService.shared.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure:
                self.showSomethingWentWrongError(nil)
            }
        }
    }
}

