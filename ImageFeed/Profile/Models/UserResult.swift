//
//  UserResult.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 03.02.2025.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let large: String
}
