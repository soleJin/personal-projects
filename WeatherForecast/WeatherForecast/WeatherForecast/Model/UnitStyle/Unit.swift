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

extension String {
    func convertToNSMutableAttributedString(ranges: [NSValue], fontSize: CGFloat, fontWeight: UIFont.Weight, fontColor: CGColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: fontColor
        ]
        let attributedString = NSMutableAttributedString(string: self)
        if let range = ranges.first as? NSRange {
            attributedString.addAttributes(attributes, range: range)
        }
        return attributedString
    }
}
