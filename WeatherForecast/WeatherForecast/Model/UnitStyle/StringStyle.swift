//
//  StringStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

enum CityName {
    static let nameList: [String] = [
        "Busan",
        "Cheonan",
        "Cheongju",
        "Chuncheon",
        "Daegu",
        "Daejeon",
        "Gongju",
        "Gumi",
        "Gunsan",
        "Gwangju",
        "Iksan",
        "Jeju",
        "Jeonju",
        "Mokpo",
        "Seosan",
        "Seoul",
        "Sokcho",
        "Suncheon",
        "Suwon",
        "Ulsan"
    ]
}

enum APIType {
    static let currentWeather = "https://api.openweathermap.org/data/2.5/weather?"
    static let forecastHourly = "https://api.openweathermap.org/data/2.5/forecast/hourly"
    static let forecastDaily = "https://api.openweathermap.org/data/2.5/forecast/daily"
    static let weatherIcon = "https://openweathermap.org/img/w/"
}
