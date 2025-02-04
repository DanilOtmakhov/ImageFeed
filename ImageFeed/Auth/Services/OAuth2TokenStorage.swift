//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let storage: UserDefaults = .standard
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
