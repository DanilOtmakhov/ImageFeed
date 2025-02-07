//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let storage: KeychainWrapper = .standard
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else { return }
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
