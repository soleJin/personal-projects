//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    private let additionalInformation: [Weather]
    var weather: Main
    let cityName: String
    var cityNameInKorean: String?
    var weatherIcon: UIImage {
        guard let iconPath = additionalInformation.first?.iconPath else { return UIImage() }
        let icon = ImageManager.getImage(iconPath)
        return icon
    }
    var weatherDescription: String {
        guard let description = additionalInformation.first?.description else { return String() }
        return description
    }
    
    enum CodingKeys: String, CodingKey {
        case additionalInformation = "weather"
        case weather = "main"
        case coordinate = "coord"
        case cityName = "name"
        case cityNameInKorean
    }
}

struct Coordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Main: Decodable {
    var temperature: Double
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
