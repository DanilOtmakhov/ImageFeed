//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 19.03.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var loadRequestCalled: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func load(for request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }

}
