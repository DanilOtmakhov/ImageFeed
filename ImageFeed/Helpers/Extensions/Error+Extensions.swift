//
//  Error+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 08.02.2025.
//

import Foundation

extension Error {
    func log(object: AnyObject) {
        print("\(String(describing: type(of: object))): \(type(of: self)) - \(self.localizedDescription)")
    }
}
