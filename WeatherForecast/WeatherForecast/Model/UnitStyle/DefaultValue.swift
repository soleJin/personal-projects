//
//  StringStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

//enum City {
//    static let nameList: [String] = [
//        "Cheonan",
//        "Cheongju",
//        "Daegu",
//        "Daejeon",
//        "Seoul"
//    ]
//}

enum InitialLocation {
    static let latitude: Double = 37.62746
    static let longtitude: Double = 126.98547
}

enum City {
    static let list = [
        Coordinate(longitude: 127.1835899, latitude: 37.7017495),
        Coordinate(longitude: 127.5590436, latitude: 36.4999476),
        Coordinate(longitude: 128.7632175, latitude: 36.0172826),
        Coordinate(longitude: 129.3344242, latitude: 35.3874414),
        Coordinate(longitude: 126.9979894, latitude: 34.053171)
    ]
}
