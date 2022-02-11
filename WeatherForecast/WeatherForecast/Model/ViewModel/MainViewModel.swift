//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

protocol CurrentWeatherDataUpdatable: class {
    func reloadData()
    func updateSegmentControl()
}

class MainViewModel {
    weak var delegate: CurrentWeatherDataUpdatable?
    var currentWeatherList = [CurrentWeather]() {
        didSet {
            delegate?.reloadData()
            let cityNameList = currentWeatherList.map { $0.cityName }
            UserDefaults.standard.setValue(cityNameList, forKey: "cityNameList")
        }
    }
    var locationWeather: CurrentWeather?
    
    var locationCoordinate: Coordinate? {
        guard let coordinate = locationWeather?.coordinate else { return nil }
        return coordinate
    }

    var locationTemperature: Double {
        guard let temperature = locationWeather?.weather.temperature else { return 0.0 }
        return temperature
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
    
    func convertTemperatureUnitFtoC(_ updateTemperature: (() -> Void)) {
        let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String
        if temperatureUnit == TemperatureUnit.F.rawValue {
            UserDefaults.standard.setValue(TemperatureUnit.C.rawValue, forKey: "temperatureUnit")
            for index in 0...numberOfCurrentWeatherList-1 {
                let temperature = currentWeatherList[index].weather.temperature
                currentWeatherList[index].weather.temperature = temperature.convertTemperatureFtoC()
            }
            guard let temperture = locationWeather?.weather.temperature else {
                return }
            locationWeather?.weather.temperature = temperture.convertTemperatureFtoC()
            updateTemperature()
        }
    }
    
    func convertTemperatureUnitCtoF(_ updateTemperature: () -> Void) {
        let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String
        if temperatureUnit == TemperatureUnit.C.rawValue {
            UserDefaults.standard.setValue(TemperatureUnit.F.rawValue, forKey: "temperatureUnit")
            for index in 0...numberOfCurrentWeatherList-1 {
                let temperature = currentWeatherList[index].weather.temperature
                currentWeatherList[index].weather.temperature = temperature.convertTemperatureCtoF()
            }
            guard let temperture = locationWeather?.weather.temperature else { return }
            locationWeather?.weather.temperature = temperture.convertTemperatureCtoF()
            updateTemperature()
        }
    }
    
    func setUpDefaultValue() {
        UserDefaults.standard.setValue(TemperatureUnit.C.rawValue, forKey: "temperatureUnit")
        if let cityNameList = UserDefaults.standard.array(forKey: "cityNameList") as? [String] {
            loadEachCurrentWeather(cityNameList: cityNameList)
        } else {
            loadEachCurrentWeather(cityNameList: City.nameList)
        }
    }
    
    private func loadEachCurrentWeather(cityNameList: [String]) {
        cityNameList.forEach({ (cityName) in
            loadCurrentWeather(cityName: cityName, latitude: nil, longtitude: nil) { (weather) in
                self.currentWeatherList.removeAll(where: { (currentWeather) -> Bool in
                    currentWeather.cityName == weather.cityName
                })
                self.append(weather)
            }
        })
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
                print("Main View Networking Error: \(error.localizedDescription)")
            }
        }
    }
}
