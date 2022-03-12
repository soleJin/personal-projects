//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

enum APIError: Error {
    case error
    case unknwon
    case invalidURL
    case noData
    case noResponse
    case noParse
}

class WeatherAPI {
    static func fetchWeather<T: Decodable>(_ apiType: String, _ latitude: Double, _ longitude: Double, completion: @escaping (Result<T, APIError>) -> Void) {
        let session = URLSession(configuration: .default)
        
        let requestUrl = URLManager.getRequestUrl(apiType, latitude, longitude)
        guard let url = requestUrl else {
            completion(Result.failure(.invalidURL))
            return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(Result.failure(.error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(Result.failure(.noResponse))
                return
            }
            guard (200...299) ~= response.statusCode else {
                checkResponseStatusCode(response)
                return
            }
            guard let safeData = data else {
                completion(Result.failure(.noData))
                return
            }
            guard let currentWeather = try? JSONDecoder().decode(T.self, from: safeData) else {
                completion(Result.failure(.noParse))
                return
            }
            completion(Result.success(currentWeather))
        }
        dataTask.resume()
    }
    
    private static func checkResponseStatusCode(_ response: HTTPURLResponse) {
        switch response.statusCode {
        case (400...499):
            print("4XX Response: \(response)")
        case (500...599):
            print("5XX Response: \(response)")
        default:
            print("Response: \(response)")
        }
    }
}
