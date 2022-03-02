//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation

protocol CurrentWeatherListDataUpdatable: AnyObject {
    func mainTableViewReloadData()
}

class MainViewModel {
    weak var currentWeatherListDelegate: CurrentWeatherListDataUpdatable?
    var currentWeatherList = [CurrentWeather]() {
        didSet {
            currentWeatherListDelegate?.mainTableViewReloadData()
            UserDefaults.standard.save(of: currentWeatherList)
        }
    }
    var locationWeather: CurrentWeather?
    var locationCoordinate: Coordinate? {
        guard let coordinate = locationWeather?.coordinate else { return nil }
        return coordinate
    }
    var locationTemperature: Double {
        guard let temperature = locationWeather?.temperature else { return 0.0 }
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
        currentWeatherList = currentWeatherList.sorted(by: {
            $0.cityName.compare($1.cityName) == .orderedDescending
        })
    }
    
    func descendingOrderHumidity() {
        currentWeatherList.sort {( $0.humidity < $1.humidity )}
    }
    
    func descendingOrderTemperature() {
        currentWeatherList.sort {( $0.temperature < $1.temperature )}
    }
    
    func ascendingOrderCityNameInKorean() {
        currentWeatherList = currentWeatherList.sorted(by: {
            $0.cityName.compare($1.cityName) == .orderedAscending
        })
    }
    
    func ascendingOrderHumidity() {
        currentWeatherList.sort {( $0.humidity > $1.humidity )}
    }
    
    func ascendingOrderTemperature() {
        currentWeatherList.sort {( $0.temperature > $1.temperature )}
    }
    
    func convertTemperatureUnitFtoC(_ updateTemperature: (() -> Void)) {
        let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String
        if temperatureUnit == TemperatureUnit.fahrenheit.rawValue {
            UserDefaults.standard.setValue(TemperatureUnit.celsius.rawValue, forKey: "temperatureUnit")
            for index in 0...numberOfCurrentWeatherList-1 {
                let temperature = currentWeatherList[index].temperature
                currentWeatherList[index].temperature = temperature.inCelsius
            }
            guard let temperture = locationWeather?.temperature else {
                return }
            locationWeather?.temperature = temperture.inCelsius
            updateTemperature()
        }
    }
    
    func convertTemperatureUnitCtoF(_ updateTemperature: () -> Void) {
        let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String
        if temperatureUnit == TemperatureUnit.celsius.rawValue {
            UserDefaults.standard.setValue(TemperatureUnit.fahrenheit.rawValue, forKey: "temperatureUnit")
            for index in 0...numberOfCurrentWeatherList-1 {
                let temperature = currentWeatherList[index].temperature
                currentWeatherList[index].temperature = temperature.inFahrenheit
            }
            guard let temperture = locationWeather?.temperature else { return }
            locationWeather?.temperature = temperture.inFahrenheit
            updateTemperature()
        }
    }
    
    func setUpDefaultValue() {
        UserDefaults.standard.setValue(TemperatureUnit.celsius.rawValue, forKey: "temperatureUnit")
        if let coordinateList = UserDefaults.standard.loadCoordinateList() {
            loadEachCurrentWeatherAndSort(with: coordinateList)
        } else {
            loadEachCurrentWeatherAndSort(with: City.coordinateList)
        }
    }
    
    private func loadEachCurrentWeatherAndSort(with loadCoordinateList: [Coordinate]) {
        loadCoordinateList.forEach({ (coordinate) in
            loadCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] (weather) in
                self?.currentWeatherList.removeAll { currentweather in
                    weather.coordinate == currentweather.coordinate
                }
                self?.append(weather)
            }
        })
    }
    
//    private func andSortByUserDefaults(with weatherList: [CurrentWeather], with coordinateList: [Coordinate]) -> [CurrentWeather] {
//        var currentWeatherList = [CurrentWeather]()
//        for coordinate in coordinateList {
//            for weather in weatherList {
//                if weather.coordinate == coordinate {
//                    currentWeatherList.append(weather)
//                }
//            }
//        }
//        return currentWeatherList
//    }
    
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        WeatherAPI.fetchWeather(APIType.currentWeather, latitude, longitude) { (result: Result<CurrentWeatherResponse, APIError>) in
            switch result {
            case .success(let currentWeather):
                guard let iconPath = currentWeather.additionalInformation.first?.iconPath,
                      let description = currentWeather.additionalInformation.first?.description else { return }
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeather.coordinate.latitude, longtitude: currentWeather.coordinate.longitude) { updateCityName in
                    let weather: CurrentWeather = CurrentWeather(coordinate: currentWeather.coordinate,
                                         cityName: updateCityName,
                                         icon: ImageManager.getImage(iconPath),
                                         description: description,
                                         humidity: currentWeather.weather.humidity,
                                         temperature: currentWeather.weather.temperature)
                    completion(weather)
                }
            case .failure(let error):
                print("Main View Networking Error: \(error.localizedDescription)")
            }
        }
    }
}

extension MainViewModel: UserAddWeatherDataUpdatable {
    func add(coordinate: Coordinate) {
        loadCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] addWeather in
            self?.currentWeatherList.insert(addWeather, at: 0)
        }
    }
}
