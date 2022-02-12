//
//  IntStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import Foundation

extension Int {
    func convertToDateString(_ expression: String) -> String? {
        guard let time = setTime(self) else { return nil }
        let formatter = setformatter(expression)
        return formatter.string(from: time)
    }
    
    private func setformatter(_ value: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kR")
        formatter.dateFormat = value
        return formatter
    }
    
    private func setTime(_ value: Int) -> Date? {
        guard let timeInterval = TimeInterval(String(self)) else { return nil }
        let time = Date(timeIntervalSince1970: timeInterval)
        return time
    }
}
