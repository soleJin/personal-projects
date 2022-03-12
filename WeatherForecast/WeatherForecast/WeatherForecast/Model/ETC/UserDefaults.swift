//
//  UserDefaults.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/20.
//

import Foundation
import MapKit

extension UserDefaults {
    func save(of weatherList: [CurrentWeather]) {
        let data = weatherList.map { $0.coordinate }
        do {
            set(try JSONEncoder().encode(data), forKey: "coordinateList")
        } catch {
            print("Unable to Encode coordinateList Error: \(error)")
        }
    }
    
    func loadCoordinateList() -> [Coordinate]? {
        guard let data = object(forKey: "coordinateList") as? Data else { return nil }
        do {
            let coordinateList = try JSONDecoder().decode([Coordinate].self, from: data)
            return coordinateList
        } catch {
            print("Unalbe to Decode coordinateList Error: \(error)")
        }
        return nil
    }
}
