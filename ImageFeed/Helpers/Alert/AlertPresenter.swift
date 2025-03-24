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
        alert.view.accessibilityIdentifier = alertModel.title
        
        for button in alertModel.buttons {
            let action = UIAlertAction(title: button.title, style: .default) { _ in
                button.handler?()
            }
            action.accessibilityIdentifier = button.title
            alert.addAction(action)
        }
        
        alert.preferredAction = alert.actions.last
        
        viewController?.present(alert, animated: true)
    }
}
