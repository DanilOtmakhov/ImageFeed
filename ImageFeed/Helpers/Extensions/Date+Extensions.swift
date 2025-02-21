//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.02.2025.
//

import Foundation

extension Date {
    static func from(
        _ string: String,
        format: String = "yyyy-MM-dd'T'HH:mm:ss",
        locale: Locale = Locale(identifier: "ru_RU")
    ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.locale = locale
        
        return formatter.date(from: string)
    }
}
