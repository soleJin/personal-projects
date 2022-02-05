//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation
import CoreLocation

struct WeatherAPI {
    static func fetchWeather<T: Decodable>(_ apiType: String, _ cityName: String?, _ location: CLLocation?, completion: @escaping (T) -> Void) {
        let session = URLSession(configuration: .default)
        
        let requestUrl = URLManager.getRequestUrl(apiType, cityName, location)
        guard let url = requestUrl else { return }
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let safeData = data,
                  let currentWeather = try? JSONDecoder().decode(T.self, from: safeData) else {
                print("---------------->Error: \(String(describing: error?.localizedDescription))")
                return
            }
            checkResponseStatusCode(response)
            completion(currentWeather)
        }
        dataTask.resume()
    }
    
    private static func checkResponseStatusCode(_ response: HTTPURLResponse) {
        switch response.statusCode {
        case (200...299): // 성공
            break
        case (400...499):// 클라이언트에러
            print("""
                Error: Client Error \(response.statusCode)
                Response: \(response)
            """)
        case (500...599): // 서버에러
            print("""
                Error: Server Error \(response.statusCode)
                Response: \(response)
            """)
        default:
            print("""
                Error: \(response.statusCode)
                Response: \(response)
            """)
        }
    }
}
