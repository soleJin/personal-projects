//
//  Unit.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

enum TemperatureUnit {
    case F
    case C
}

enum WeatherSymbols {
    static let humidity = "%"
    static let temperature = "º"
    static let pressure = "hPa"
    static let windSpeed = "m/s"
}

extension String {
    func convertTemperatureCtoFString() -> String? {
        let array = self.components(separatedBy: " ")
        guard let value = array.first,
              let valueDouble = Double(value) else { return nil }
        return "\(valueDouble.convertTemperatureFtoC()) \(WeatherSymbols.temperature)"
    }
    
    func convertTemperatureFtoCString() -> String? {
        let array = self.components(separatedBy: " ")
        guard let value = array.first,
              let valueDouble = Double(value) else { return nil }
        return "\(valueDouble.convertTemperatureFtoC()) \(WeatherSymbols.temperature)"
    }
}


extension Double {
    func convertTemperatureFtoC() -> Double {
        return (self - 32) * 5/9
    }
    
    func convertTemperatureCtoF() -> Double {
        return self * 9/5 + 32
    }
}
