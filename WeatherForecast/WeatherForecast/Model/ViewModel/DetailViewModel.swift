//
//  DetailViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

protocol DetailWeatherDataUpdatable: class {
    func updateWeather(data: HourlyWeather)
    func reloadData()
}

class DetailViewModel {
    weak var delegate: DetailWeatherDataUpdatable?
    var coord: Coordinate? 
    var address: String?
    var currnetWeather: HourlyWeather?
    var hourlyWeatherList = [HourlyWeather]()
    var dailyWeatherList = [DailyWeather]()
    var numberOfDailyWeatherList: Int {
        return dailyWeatherList.count
    }
    var numberOfHourlyWeatherList: Int {
        return hourlyWeatherList.count
    }
    
    func loadDetailWeather() {
        guard let coord = coord else { return }
        WeatherAPI.fetchWeather(APIType.dailyWeather, nil, coord.latitude, coord.longitude) { (result: Result<DetailWeather, APIError>) in
            switch result {
            case .success(let dailyWeatherData):
                self.hourlyWeatherList = dailyWeatherData.hourly
                self.dailyWeatherList = dailyWeatherData.daily
                self.currnetWeather = dailyWeatherData.current
                self.delegate?.updateWeather(data: dailyWeatherData.current)
                self.delegate?.reloadData()
            case .failure(let error):
                print("Detail View Networking Error: \(error.localizedDescription)")
            }
        }
        AddressManager.convertCityNameEnglishToKoreanSimply(latitude: coord.latitude, longtitude: coord.longitude) { (adress) in
            self.address = adress
        }
    }
}
