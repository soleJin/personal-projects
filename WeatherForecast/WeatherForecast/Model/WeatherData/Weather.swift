//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

struct CurrentWeather: Decodable {
    let coord: Coord
    let additionalInformation: [Weather]
    var weather: Main
    let wind: Wind
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case additionalInformation = "weather"
        case weather = "main"
        case wind, coord
        case cityName = "name"
    }
}

struct Coord: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Main: Decodable {
    var temperature, feelsLike, minimumTemperature, maximumTemperature: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure, humidity
    }
}

struct Weather: Decodable {
    let description, iconPath: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconPath = "icon"
    }
}

struct Wind: Decodable {
    let speed: Double
}
