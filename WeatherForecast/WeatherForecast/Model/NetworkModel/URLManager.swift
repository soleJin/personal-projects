//
//  URLManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation
import CoreLocation

struct URLManager {
    static func getRequestUrl(_ apiType: String, _ cityName: String? = nil, _ location: CLLocation? = nil ) -> URL? {
        var urlComponents = URLComponents(string: apiType)
        let appIdQuery = URLQueryItem(name: "appid", value: "179f9f1734b59fcdd8627cb64e9fae5d")
        let languageQuery = URLQueryItem(name: "lang", value: "kr")
        let cityNameQuery = URLQueryItem(name: "q", value: cityName)
        let latitudeQuery = URLQueryItem(name: "lat", value: "location?.coordinate.latitude")
        let longitudeQuery = URLQueryItem(name: "lon", value: "location?.coordinate.longitude")
        urlComponents?.queryItems?.append(contentsOf: [cityNameQuery, languageQuery, appIdQuery, latitudeQuery, longitudeQuery])
        let requesturl = urlComponents?.url
        return requesturl
    }
}
