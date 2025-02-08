//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
