//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

class MainViewModel {
    var currentWeatherList = [CurrentWeather]()
    var sortedWeatherList: [CurrentWeather] {
        let sortedList = currentWeatherList.sorted { (prevWeather, nextWeather) -> Bool in
            return prevWeather.cityName < nextWeather.cityName 
        }.compactMap { $0 }
        return sortedList
    }
    var locationWeather: CurrentWeather?
    var locationTemperature: Double {
        guard let temperature = locationWeather?.weather.temperature else { return 0.0 }
        return temperature
    }
    var locationDescription: String {
        guard let description = locationWeather?.additionalInformation.first?.description else { return "" }
        return description
    }
    var locationIconPath: String {
        guard let iconPath = locationWeather?.additionalInformation.first?.iconPath else { return "" }
        return iconPath
    }
    
    var numberOfCurrentWeatherList: Int {
        return currentWeatherList.count
    }

    func sortedWeather(at index: Int) -> CurrentWeather {
        return sortedWeatherList[index]
    }
    
    func append(_ currentWeather: CurrentWeather) {
        currentWeatherList.append(currentWeather)
    }

    func convertTemperatureUnitFtoC() {
        for index in 0...numberOfCurrentWeatherList-1 {
            currentWeatherList[index].weather.temperature -= 273.15
        }
    }
    
    func convertTemperatureUnitCtoF() {
        for index in 0...numberOfCurrentWeatherList-1 {
            currentWeatherList[index].weather.temperature += 273.15
        }
    }
}

