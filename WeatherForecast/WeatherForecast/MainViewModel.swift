//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation

class MainViewModel {
    var currentWeatherList: [CurrentWeather] = [
        CurrentWeather(additionalInformation: [Weather(description: nil, iconPath: "01")], weather: Main(temperature: 32, feelsLike: nil, minimumTemperature: nil, maximumTemperature: nil, pressure: nil, humidity: 40), wind: nil, cityName: "서울"),
        CurrentWeather(additionalInformation: [Weather(description: nil, iconPath: "01")], weather: Main(temperature: 2, feelsLike: nil, minimumTemperature: nil, maximumTemperature: nil, pressure: nil, humidity: 10), wind: nil, cityName: "인천"),
        CurrentWeather(additionalInformation: [Weather(description: nil, iconPath: "01")], weather: Main(temperature: -8, feelsLike: nil, minimumTemperature: nil, maximumTemperature: nil, pressure: nil, humidity: 40), wind: nil, cityName: "경기"),
        CurrentWeather(additionalInformation: [Weather(description: nil, iconPath: "01")], weather: Main(temperature: 0, feelsLike: nil, minimumTemperature: nil, maximumTemperature: nil, pressure: nil, humidity: 35), wind: nil, cityName: "창원"),
        CurrentWeather(additionalInformation: [Weather(description: nil, iconPath: "01")], weather: Main(temperature: 5, feelsLike: nil, minimumTemperature: nil, maximumTemperature: nil, pressure: nil, humidity: 20), wind: nil, cityName: "울산")
    ]
    var sortedWeatherList: [CurrentWeather] {
        let sortedList = currentWeatherList.sorted { (prevWeather, nextWeather) -> Bool in
            return prevWeather.cityName ?? "" < nextWeather.cityName ?? ""
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
}
