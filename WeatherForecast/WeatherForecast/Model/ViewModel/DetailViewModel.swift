//
//  DetailViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

protocol DetailWeatherDataUpdatable: AnyObject {
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
    
    func loadDetailWeather() {
        guard let coord = coord else { return }
        WeatherAPI.fetchWeather(APIType.dailyWeather, nil, coord.latitude, coord.longitude) { [weak self] (result: Result<DetailWeather, APIError>) in
            switch result {
            case .success(let dailyWeatherData):
                self?.hourlyWeatherList = dailyWeatherData.hourly
                self?.dailyWeatherList = dailyWeatherData.daily
                self?.currnetWeather = dailyWeatherData.current
                self?.delegate?.updateWeather(data: dailyWeatherData.current)
                self?.delegate?.reloadData()
            case .failure(let error):
                print("Detail View Networking Error: \(error.localizedDescription)")
            }
        }
        AddressManager.convertCityNameEnglishToKoreanSimply(latitude: coord.latitude, longtitude: coord.longitude) { [weak self] (adress) in
            self?.address = adress
        }
    }
    
    func getCityNameAndSetUserDefaults() {
        guard let coord = coord else { return }
        WeatherAPI.fetchWeather(APIType.currentWeather, nil, coord.latitude, coord.longitude) { (result: Result<CurrentWeather, APIError>) in
            switch result {
            case .success(let currentWeather):
                let cityName = currentWeather.cityName
                var cityNameList = UserDefaults.standard.array(forKey: "cityNameList") as? [String]
                cityNameList?.append(cityName)
                UserDefaults.standard.set(cityNameList, forKey: "cityNameList")
                return
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
}
