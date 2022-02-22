//
//  UserDefaults.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/20.
//

import Foundation

extension UserDefaults {
    func save(of weatherList: [CurrentWeather]) {
        let data = weatherList.map { $0.coordinate }
        set(try? JSONEncoder().encode(data), forKey: "coordinateList")
    }
    
    func loadCoordinateList() -> [Coordinate]? {
        guard let data = object(forKey: "coordinateList") as? Data else { return nil }
        guard let coordinateList = try? JSONDecoder().decode([Coordinate].self, from: data) else { return nil }
        return coordinateList
    }
}
