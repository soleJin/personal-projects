//
//  IntStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import Foundation

extension Int {
    func convertToHourlyString() -> String? {
        guard let timeInterval = TimeInterval(String(self)) else { return nil }
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kR")
        formatter.dateFormat = "HH시"
        return formatter.string(from: utcTime)
    }
    
    func convertToDailyString() -> String? {
        guard let timeInterval = TimeInterval(String(self)) else { return nil }
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kR")
        formatter.dateFormat = "eeee"
        return formatter.string(from: utcTime)
    }
}
