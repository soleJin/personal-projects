//
//  Unit.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

enum TemperatureUnit: String {
    case F
    case C
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
    func convertTemperatureFtoC() -> Double {
        return (self - 32) * 5/9
    }
    
    func convertTemperatureCtoF() -> Double {
        return self * 9/5 + 32
    }
    
    func toOneDecimalPlaceInString() -> String {
         return String(format: "%.1f", self)
     }
}

extension String {
    func convertToNSMutableAttributedString(ranges: [NSValue]) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
        let attributedString = NSMutableAttributedString(string: self)
        if let range = ranges.first as? NSRange {
            attributedString.addAttributes(attributes, range: range)
        }
        return attributedString
    }
}
