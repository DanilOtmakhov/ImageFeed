//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.01.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
    
    let accessToken, tokenType, scope: String
    let createdAt: Int
}
