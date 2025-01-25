//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    
    let accessToken, tokenType, scope: String
    let createdAt: Int
}
