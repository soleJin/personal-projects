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

