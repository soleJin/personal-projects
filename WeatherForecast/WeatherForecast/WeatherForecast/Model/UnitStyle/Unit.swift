//
//  Unit.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

enum TemperatureUnit: String {
    case fahrenheit
    case celsius
}

enum WeatherSymbols {
    static let humidity = "%"
    static let temperature = "º"
    static let pressure = "hPa"
    static let windSpeed = "m/s"
}

enum TimeUnit {
    static let daily = "eeee"
    static let hourly = "HH시"
    static let minutely = "HH시 mm분"
}

extension Double {
    var inFahrenheit: Double {
        return (self - 273.15) * 9/5 + 32
    }
    
    var inCelsius: Double {
        return self - 273.15
    }
    
    var oneDecimalPlaceInString: String {
        return String(format: "%.1f", self)
    }
}

extension Int {
    func convertToDateString(_ timeUnit: String) -> String? {
        guard let time = setTime(self) else { return nil }
        let formatter = setformatter(timeUnit)
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
