//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 04.03.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
  
    private init() { }

    func logout() {
        resetAuthToken()
        resetProfile()
        cleanCookies()
    }
    
    private func resetAuthToken() {
        OAuth2TokenStorage().resetToken()
    }
    
    private func resetProfile() {
        ProfileService.shared.resetProfile()
        ProfileImageService.shared.resetImageURL()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
    
