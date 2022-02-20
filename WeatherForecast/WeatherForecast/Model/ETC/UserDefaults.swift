//
//  UserDefaults.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/20.
//

import Foundation

extension UserDefaults {
    func saveCoordinate(of weatherList: [CurrentWeather]) {
        let data = weatherList.map {
            [
                "latitude": $0.coordinate.latitude,
                "longitude": $0.coordinate.longitude
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "cityList")
    }
    
    func loadCityList() -> [Coordinate]? {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "cityList") as? [[String: Any]] else { return nil }
        let cityList: [Coordinate] = data.compactMap {
            guard let latitude = $0["latitude"] as? Double else { return nil }
            guard let longitude = $0["longitude"] as? Double else { return nil }
            return Coordinate(longitude: longitude, latitude: latitude)
        }
        return cityList
    }
}
