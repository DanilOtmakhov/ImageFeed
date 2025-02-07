//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let storage: KeychainWrapper = .standard
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.token.rawValue)
        }
        set {
            if let newValue {
                storage.set(newValue, forKey: Keys.token.rawValue)
            } else {
                storage.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
}
