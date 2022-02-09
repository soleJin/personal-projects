//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation

protocol DataUpdatable: class {
    func reloadData()
}

class MainViewModel {
    weak var delegate: DataUpdatable?
    let cityNameList = City.nameList
    let userDefaults = UserDefaults.standard
    var currentWeatherList = [CurrentWeather]() {
        didSet {
            delegate?.reloadData()
        }
    }
    var locationWeather: CurrentWeather?

    var locationTemperature: Double {
        guard let temperature = locationWeather?.weather.temperature else { return 0.0 }
        return temperature
    }
    var numberOfCurrentWeatherList: Int {
        return currentWeatherList.count
    }
    
    func setUserDefaults() {
        userDefaults.setValue(cityNameList, forKey: "cityNameList")
    }

    func currentWeather(at index: Int) -> CurrentWeather {
        return currentWeatherList[index]
    }
    
    func append(_ currentWeather: CurrentWeather) {
        currentWeatherList.append(currentWeather)
    }
    
    func delete(at index: Int) {
        currentWeatherList.remove(at: index)
    }
    
    func descendingOrderCityNameInKorean() {
        currentWeatherList.sort {( $0.cityNameInKorean ?? ""
                                    < $1.cityNameInKorean ?? "" )}
    }
    
    func descendingOrderHumidity() {
        currentWeatherList.sort {( $0.weather.humidity < $1.weather.humidity )}
    }
    
    func descendingOrderTemperature() {
        currentWeatherList.sort {( $0.weather.temperature < $1.weather.temperature )}
    }
    
    func ascendingOrderCityNameInKorean() {
        currentWeatherList.sort {( $0.cityNameInKorean ?? "" > $1.cityNameInKorean ?? "" )}
    }
    
    func ascendingOrderHumidity() {
        currentWeatherList.sort {( $0.weather.humidity > $1.weather.humidity )}
    }
    
    func ascendingOrderTemperature() {
        currentWeatherList.sort {( $0.weather.temperature > $1.weather.temperature )}
    }
    
    func convertTemperatureUnitFtoC(_ updateTemperature: () -> Void) {
        for index in 0...numberOfCurrentWeatherList-1 {
            let temperature = currentWeatherList[index].weather.temperature
            currentWeatherList[index].weather.temperature = temperature.convertTemperatureFtoC()
        }
        guard let temperture = locationWeather?.weather.temperature else {
            return }
        locationWeather?.weather.temperature = temperture.convertTemperatureFtoC()
        updateTemperature()
    }
    
    func convertTemperatureUnitCtoF(_ temperature: () -> Void) {
        for index in 0...numberOfCurrentWeatherList-1 {
            let temperature = currentWeatherList[index].weather.temperature
            currentWeatherList[index].weather.temperature = temperature.convertTemperatureCtoF()
        }
        guard let temperture = locationWeather?.weather.temperature else {
            return }
        locationWeather?.weather.temperature = temperture.convertTemperatureCtoF()
        temperature()
    }
    
    
    func loadCurrentWeather(cityName: String?, latitude: Double?, longtitude: Double?, completion: @escaping (CurrentWeather) -> Void) {
        WeatherAPI.fetchWeather(APIType.currentWeather, cityName, latitude, longtitude) { (result: Result<CurrentWeather, APIError>) in
            switch result {
            case .success(let currentWeather):
                var weather = currentWeather
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeather.coordinate.latitude, longtitude: currentWeather.coordinate.longitude) { (updateCityName) in
                    weather.cityNameInKorean = updateCityName
                    completion(weather)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

