//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 20.01.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
