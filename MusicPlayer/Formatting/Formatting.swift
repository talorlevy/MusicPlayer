//
//  Formatting.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/25/23.
//

import Foundation


struct Formatting {

    static func formatDate(dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        inputFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }

    static func priceToString(price: Double) -> String {
        let price = String(price)
        return "Price: $\(price)"
    }
}
