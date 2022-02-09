//
//  StringStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

enum City {
    static var nameList: [String] = [
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
    static let dailyWeather = "https://api.openweathermap.org/data/2.5/onecall?"
    static let weatherIcon = "https://openweathermap.org/img/w/"
}
