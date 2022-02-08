//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation

class MainViewModel {
    var currentWeatherList = [CurrentWeather]()

    var locationWeather: CurrentWeather?
    
    var locationCityName: String {
        guard let cityName = locationWeather?.cityNameInKorean else { return "" }
        return cityName
    }
    
    var locationDescription: String {
        guard let description = locationWeather?.weatherDescription else { return String() }
        return description
    }
    var locationTemperature: Double {
        guard let temperature = locationWeather?.weather.temperature else { return 0.0 }
        return temperature
    }
    
    var locationIcon: UIImage {
        guard let icon = locationWeather?.weatherIcon else { return UIImage() }
        return icon
    }
    
    var numberOfCurrentWeatherList: Int {
        return currentWeatherList.count
    }

    func currentWeather(at index: Int) -> CurrentWeather {
        return currentWeatherList[index]
    }
    
    func append(_ currentWeather: CurrentWeather) {
        currentWeatherList.append(currentWeather)
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
}

