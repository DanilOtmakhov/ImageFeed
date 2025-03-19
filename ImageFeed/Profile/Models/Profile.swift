//
//  Profile.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 31.01.2025.
//

import Foundation

public struct Profile {
    let username: String
    let name: String
    let login: String
    let bio: String
    
    public init(username: String, name: String, login: String, bio: String) {
        self.username = username
        self.name = name
        self.login = login
        self.bio = bio
    }
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        self.login = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}
