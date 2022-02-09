//
//  DailyWeather.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

struct DailyWeather: Decodable {
    let latitude, longitude: Double
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
    var address: String?
    
    enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
            case current, hourly, daily
    }
}

struct Current: Decodable {
    let dt: Int
    let temp: Double
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let weather: [Weather]
    var weatherDescription: String {
        return weather.description
    }
    var icon: UIImage {
        guard let iconPath = weather.first?.iconPath else { return UIImage() }
        return ImageManager.getImage(iconPath)
    }
}

struct Daily: Decodable {
    let dateTime: Int
    let temperature: Temperature
    let weather: [Weather]
    var icon: UIImage {
        guard let iconPath = weather.first?.iconPath else { return UIImage() }
        return ImageManager.getImage(iconPath)
    }
    
    enum CodingKeys: String, CodingKey {
            case dateTime = "dt"
            case temperature = "temp"
            case weather
    }
}

struct Temperature: Decodable {
    let minimum: Double
    let maximum: Double
    
    enum CodingKeys: String, CodingKey {
            case minimum = "min"
            case maximum = "max"
    }
}
