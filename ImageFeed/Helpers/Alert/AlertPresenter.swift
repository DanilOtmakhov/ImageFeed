//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(alertModel: AlertModel)
}

final class AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion?()
        }
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
