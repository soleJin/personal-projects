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
        "Daejeon"
//        "Gongju",
//        "Gwangju",
//        "Jeju",
//        "Jeonju",
//        "Mokpo",
//        "Seoul",
//        "Suwon",
//        "Ulsan"
    ]
}

enum InitialLocation {
    static let latitude: Double = 37.62746
    static let longtitude: Double = 126.98547
}
