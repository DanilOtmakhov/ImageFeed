//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let buttons: [(title: String, handler: (() -> Void)?)]
}
