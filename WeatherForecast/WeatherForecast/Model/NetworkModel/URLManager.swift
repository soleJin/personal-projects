//
//  URLManager.swift
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

struct URLManager {
    static func getRequestUrl(_ apiType: String, _ latitude: Double, _ longitude: Double) -> URL? {
        var urlComponents = URLComponents(string: apiType)
        let appIdQuery = URLQueryItem(name: "appid", value: "179f9f1734b59fcdd8627cb64e9fae5d")
        let languageQuery = URLQueryItem(name: "lang", value: "kr")
        let unitsQuery = URLQueryItem(name: "units", value: "metric")
        let latitudeQuery = URLQueryItem(name: "lat", value: "\(String(latitude))")
        let longitudeQuery = URLQueryItem(name: "lon", value: "\(String(longitude))")
        urlComponents?.queryItems?.append(contentsOf: [languageQuery, appIdQuery, unitsQuery, latitudeQuery, longitudeQuery])
        guard let requesturl = urlComponents?.url else {
            print("-------------nourl")
            return nil
        }
        return requesturl
    }
}
