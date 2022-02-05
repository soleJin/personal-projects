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
        guard let latitudeValue = location?.coordinate.latitude,
              let lontitudeValue = location?.coordinate.longitude else {
            urlComponents?.queryItems?.append(contentsOf: [cityNameQuery, languageQuery, appIdQuery])
            let requesturl = urlComponents?.url
            return requesturl
        }
        print(String(latitudeValue))
        let latitudeQuery = URLQueryItem(name: "lat", value: "\(String(latitudeValue))")
        let longitudeQuery = URLQueryItem(name: "lon", value: "\(String(lontitudeValue))")
        urlComponents?.queryItems?.append(contentsOf: [appIdQuery, languageQuery, latitudeQuery, longitudeQuery])
        let requesturl = urlComponents?.url
        return requesturl
    }
}
