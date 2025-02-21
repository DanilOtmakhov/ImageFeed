//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.02.2025.
//

import Foundation

extension Date {
    private static let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    static func from(_ string: String) -> Date? {
        return isoDateFormatter.date(from: string)
    }
    
    var dateString: String {
        return Date.displayDateFormatter.string(from: self)
    }
}

