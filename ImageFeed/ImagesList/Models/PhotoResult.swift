//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 20.02.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width, height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let thumb: String
    let full: String
}
