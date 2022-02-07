//
//  URLManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

struct URLManager {
    static func getRequestUrl(_ apiType: String, _ cityName: String? = nil, _ latitude: Double? = nil, _ longitude: Double? = nil) -> URL? {
        var urlComponents = URLComponents(string: apiType)
        let appIdQuery = URLQueryItem(name: "appid", value: "179f9f1734b59fcdd8627cb64e9fae5d")
        let languageQuery = URLQueryItem(name: "lang", value: "kr")
        let cityNameQuery = URLQueryItem(name: "q", value: cityName)
        let unitsQuery = URLQueryItem(name: "units", value: "metric")
        urlComponents?.queryItems?.append(contentsOf: [languageQuery, appIdQuery, unitsQuery])
        guard let latitude = latitude,
              let longtitude = longitude else {
            urlComponents?.queryItems?.append(contentsOf: [cityNameQuery])
            let requesturl = urlComponents?.url
            return requesturl
        }
        let latitudeQuery = URLQueryItem(name: "lat", value: "\(String(latitude))")
        let longitudeQuery = URLQueryItem(name: "lon", value: "\(String(longtitude))")
        urlComponents?.queryItems?.append(contentsOf: [latitudeQuery, longitudeQuery])
        let requesturl = urlComponents?.url
        return requesturl
    }
}
