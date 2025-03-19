//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import Foundation

public struct AlertModel {
    let title: String
    let message: String?
    let buttons: [(title: String, handler: (() -> Void)?)]
}
