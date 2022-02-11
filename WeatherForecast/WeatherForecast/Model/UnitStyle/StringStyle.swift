//
//  StringStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

enum APIType {
    static let currentWeather = "https://api.openweathermap.org/data/2.5/weather?"
    static let dailyWeather = "https://api.openweathermap.org/data/2.5/onecall?"
    static let weatherIcon = "https://openweathermap.org/img/w/"
}

enum City {
    static let nameList: [String] = [
        "Cheonan",
        "Cheongju",
        "Daegu",
        "Daejeon",
        "Gongju",
        "Gwangju",
        "Jeju",
        "Jeonju",
        "Mokpo",
        "Seoul",
        "Suwon",
        "Ulsan",
        "Seogwipo"
    ]
}
