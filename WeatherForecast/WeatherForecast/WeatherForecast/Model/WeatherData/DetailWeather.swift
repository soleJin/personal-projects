//
//  DailyWeather.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

struct DetailWeather: Decodable {
    let latitude, longitude: Double
    let current: HourlyWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case current, hourly, daily
    }
}

struct HourlyWeather: Decodable {
    let dateTime: Int
    let temperature: Double
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let sunrise: Int?
    let sunset: Int?
    private let weather: [Weather]
    let feelsLike: Double
    var weatherDescription: String {
        guard let description = weather.first?.description else { return String() }
        return description
    }
    var iconPath: String {
        guard let iconPath = weather.first?.iconPath else { return String() }
        return iconPath
    }
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "temp"
        case windSpeed = "wind_speed"
        case feelsLike = "feels_like"
        case pressure, humidity, weather, sunrise, sunset
    }
}

struct DailyWeather: Decodable {
    let dateTime: Int
    let temperature: Temperature
    let weather: [Weather]
    var iconPath: String {
        guard let iconPath = weather.first?.iconPath else { return String() }
        return iconPath
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
