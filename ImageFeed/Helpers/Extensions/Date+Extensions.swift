//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Danil Otmakhov on 21.02.2025.
//

import Foundation

extension Date {
    
    enum DateConversionError: Error {
        case invalidFormat
    }
    
    private static let isoDateFormatter = ISO8601DateFormatter()

    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    static func from(_ string: String) throws -> Date {
        guard let date = isoDateFormatter.date(from: string) else {
            throw DateConversionError.invalidFormat
        }
        return date
    }
    
    var dateString: String {
        return Date.displayDateFormatter.string(from: self)
    }
    
}

