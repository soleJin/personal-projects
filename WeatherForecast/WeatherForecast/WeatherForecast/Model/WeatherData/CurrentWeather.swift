//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

struct CurrentWeather {
    var index: Int = 0
    let coordinate: Coordinate
    let cityName: String
    let iconPath: String
    let description: String
    let humidity: Int
    let temperature: Double
}

struct CurrentWeatherResponse: Decodable {
    let coordinate: Coordinate
    let additionalInformation: [Weather]
    let weather: Main
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case additionalInformation = "weather"
        case weather = "main"
        case coordinate = "coord"
        case cityName = "name"
    }
}

struct Coordinate: Codable, Equatable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude ? true : false
    }
}

struct Main: Decodable {
    let temperature: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
    }
}

struct Weather: Decodable {
    let description, iconPath: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconPath = "icon"
    }
}
