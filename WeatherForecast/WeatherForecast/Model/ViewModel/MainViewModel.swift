//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

protocol CurrentWeatherDataUpdatable: AnyObject {
    func reloadData()
}

class MainViewModel {
    weak var delegate: CurrentWeatherDataUpdatable?
    var currentWeatherList = [CurrentWeather]() {
        didSet {
            delegate?.reloadData()
            let cityNameList = currentWeatherList.map { $0.cityName }
            UserDefaults.standard.setValue(cityNameList, forKey: "cityNameList")
            dump("----------mainview namelist \(cityNameList)")
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
            $0.cityNameInKorean.compare($1.cityNameInKorean) == .orderedDescending
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
            $0.cityNameInKorean.compare($1.cityNameInKorean) == .orderedAscending
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
        if temperatureUnit == TemperatureUnit.F.rawValue {
            UserDefaults.standard.setValue(TemperatureUnit.C.rawValue, forKey: "temperatureUnit")
            for index in 0...numberOfCurrentWeatherList-1 {
                let temperature = currentWeatherList[index].temperature
                currentWeatherList[index].temperature = temperature.convertTemperatureFtoC()
            }
            guard let temperture = locationWeather?.temperature else {
                return }
            locationWeather?.temperature = temperture.convertTemperatureFtoC()
            updateTemperature()
        }
    }
    
    func convertTemperatureUnitCtoF(_ updateTemperature: () -> Void) {
        let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String
        if temperatureUnit == TemperatureUnit.C.rawValue {
            UserDefaults.standard.setValue(TemperatureUnit.F.rawValue, forKey: "temperatureUnit")
            for index in 0...numberOfCurrentWeatherList-1 {
                let temperature = currentWeatherList[index].temperature
                currentWeatherList[index].temperature = temperature.convertTemperatureCtoF()
            }
            guard let temperture = locationWeather?.temperature else { return }
            locationWeather?.temperature = temperture.convertTemperatureCtoF()
            updateTemperature()
        }
    }
    
    func setUpDefaultValue() {
        UserDefaults.standard.setValue(TemperatureUnit.C.rawValue, forKey: "temperatureUnit")
        if let cityNameList = UserDefaults.standard.array(forKey: "cityNameList") as? [String] {
            loadEachCurrentWeatherAndSortByUser(cityNameList: cityNameList)
        } else {
            loadEachCurrentWeatherAndSortByUser(cityNameList: City.nameList)
        }
    }
    
    private func loadEachCurrentWeatherAndSortByUser(cityNameList: [String]) {
        var weatherList = [CurrentWeather]()
        cityNameList.forEach({ (cityName) in
            loadCurrentWeather(cityName: cityName, latitude: nil, longtitude: nil) { [weak self] (weather) in
                guard let self = self else { return }
                weatherList.append(weather)
                if weatherList.count == cityNameList.count {
                    print("있니?")
                    for name in cityNameList {
                        if let index = weatherList.firstIndex(where: { name == $0.cityName }) {
                            self.currentWeatherList.removeAll { currentWeather in
                                currentWeather.cityName == weatherList[index].cityName
                            }
                            self.append(weatherList[index])
                        }
                    }
                }
            }
        })
    }
    
    func loadCurrentWeather(cityName: String?, latitude: Double?, longtitude: Double?, completion: @escaping (CurrentWeather) -> Void) {
        WeatherAPI.fetchWeather(APIType.currentWeather, cityName, latitude, longtitude) { (result: Result<CurrentWeatherResponse, APIError>) in
            switch result {
            case .success(let currentWeather):
                guard let iconPath = currentWeather.additionalInformation.first?.iconPath,
                      let description = currentWeather.additionalInformation.first?.description else { return }
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeather.coordinate.latitude, longtitude: currentWeather.coordinate.longitude) { updateCityName in
                    let weather: CurrentWeather = CurrentWeather(coordinate: currentWeather.coordinate,
                                         cityName: currentWeather.cityName,
                                         cityNameInKorean: updateCityName,
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
