//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

class MainViewModel {
    var currentWeatherList = [CurrentWeather]()
    
    var locationWeather: CurrentWeather?
    
    var locationDescription: String {
        guard let description = locationWeather?.additionalInformation.first?.description else { return "" }
        return description
    }
    var locationTemperature: Double {
        guard let temperature = locationWeather?.weather.temperature else { return 0.0 }
        return temperature
    }
    
    var locationIconPath: String {
        guard let iconPath = locationWeather?.additionalInformation.first?.iconPath else { return "" }
        return iconPath
    }
    
    var numberOfCurrentWeatherList: Int {
        return currentWeatherList.count
    }

    func currentWeather(at index: Int) -> CurrentWeather {
        return currentWeatherList[index]
    }
    
    func append(_ currentWeather: CurrentWeather) {
        currentWeatherList.insert(currentWeather, at: 0)
    }
    
    func descendingOrderCityName() {
        currentWeatherList.sort { (prevWeather, nextWeather) -> Bool in
            return prevWeather.cityName < nextWeather.cityName
        }
    }
    
    func descendingOrderHumidity() {
        currentWeatherList.sort { (prevWeather, nextWeather) -> Bool in
            return prevWeather.weather.humidity < nextWeather.weather.humidity
        }
    }
    
    func descendingOrderTemperature() {
        currentWeatherList.sort { (prevWeather, nextWeather) -> Bool in
            return prevWeather.weather.temperature < nextWeather.weather.temperature
        }
    }
    
    func ascendingOrderCityName() {
        currentWeatherList.sort { (prevWeather, nextWeather) -> Bool in
            return prevWeather.cityName > nextWeather.cityName
        }
    }
    
    func ascendingOrderHumidity() {
        currentWeatherList.sort { (prevWeather, nextWeather) -> Bool in
            return prevWeather.weather.humidity > nextWeather.weather.humidity
        }
    }
    
    func ascendingOrderTemperature() {
        currentWeatherList.sort { (prevWeather, nextWeather) -> Bool in
            return prevWeather.weather.temperature > nextWeather.weather.temperature
        }
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
}

