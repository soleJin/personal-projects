//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

protocol SendErrorMessage: NSObject {
    func sendErrorMessage()
}

class WeatherAPI {
    weak static var delegate: SendErrorMessage?
    
    static func fetchWeather<T: Decodable>(_ apiType: String, _ cityName: String?, _ latitude: Double?, _ longitude: Double?, completion: @escaping (Result<T, APIError>) -> Void) {
        let session = URLSession(configuration: .default)
        
        let requestUrl = URLManager.getRequestUrl(apiType, cityName, latitude, longitude)
        guard let url = requestUrl else {
            completion(Result.failure(.invalidURL))
            return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(Result.failure(.error))
                return
            }
            if let responseError = checkResponseStatusCode(response as! HTTPURLResponse) {
                completion(Result.failure(responseError as! APIError))
                return
            }
            guard let safeData = data else {
                completion(Result.failure(.noData))
                return
            }
            guard let currentWeather = try? JSONDecoder().decode(T.self, from: safeData) else {
                completion(Result.failure(.dataDecodingError))
                return
            }
            completion(Result.success(currentWeather))
        }
        dataTask.resume()
    }
    
    private static func checkResponseStatusCode(_ response: HTTPURLResponse) -> Error? {
        switch response.statusCode {
        case (200...299):
            return nil
        case (400...499):
            print("Response: \(response)")
            delegate?.sendErrorMessage()
            return APIError.clientError
        case (500...599):
            print("Response: \(response)")
            return APIError.ServerError
        default:
            print("Response: \(response)")
            return APIError.unknwon
        }
    }
}
