//
//  Error.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/08.
//

import Foundation

enum APIError: Error {
    case error
    case unknwon
    case invalidURL
    case noData
    case noResponse
    case clientError
    case ServerError
    case dataDecodingError
}
