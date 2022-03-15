//
//  DictionaryStyle.swift
//  WeatherForecast
//
//  Created by sole on 2022/03/15.
//

import Foundation

extension Dictionary where Value: Equatable {
    func findKey(for value: Value) -> Key? {
        return first(where: { $1 == value })?.key
    }
}
