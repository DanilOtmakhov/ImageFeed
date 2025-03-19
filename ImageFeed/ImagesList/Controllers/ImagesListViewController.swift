//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 26.12.2024.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(from: Int, to: Int)
    func showSomethingWentWrongError(_ handler: (() -> Void)?)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        $0.backgroundColor = .ypBlack
        $0.dataSource = self
        $0.delegate = self
        $0.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        $0.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    // MARK: - Internal Properties
    
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private Properties
    
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photo(at: indexPath.row) else { preconditionFailure("Index out of range") }
        cell.config(with: photo)
        cell.delegate = self
    }

    func updateTableViewAnimated(from: Int, to: Int) {
        print("Old Count: \(from), New Count: \(to)")
        
        tableView.performBatchUpdates {
            let indexPaths = (from..<to).map {
                IndexPath(row: $0, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func showSomethingWentWrongError(_ handler: (() -> Void)? = nil) {
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
    
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { preconditionFailure("Presenter doesn't exist") }
        return presenter.photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
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
        guard let presenter else { preconditionFailure("Presenter doesn't exist") }
        guard let photo = presenter.photo(at: indexPath.row) else { preconditionFailure("Index out of range") }
        
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.configure(with: photo)
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { preconditionFailure("Presenter doesn't exist") }
        guard let photo = presenter.photo(at: indexPath.row) else { preconditionFailure("Index out of range") }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageHeight = photo.size.height
        let imageWidth = photo.size.width
        let imageViewWidth = view.bounds.width - imageInsets.left - imageInsets.right
        
        return imageHeight * (imageViewWidth / imageWidth) + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchNextPhotosPageIfNeeded(indexPath.row)
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        presenter?.changeLikeForPhoto(at: indexPath.row) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked)
            case .failure:
                self.showSomethingWentWrongError()
            }
        }
    }
}

