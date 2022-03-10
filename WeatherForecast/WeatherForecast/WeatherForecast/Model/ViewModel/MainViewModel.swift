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
        guard let temperature = locationWeather?.temperature else { return Double() }
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
    
    func setUpDefaultValue() {
        DispatchQueue.global().async { [weak self] in
            if let coordinateList = UserDefaults.standard.loadCoordinateList() {
                self?.loadEachCurrentWeatherAndSort(with: coordinateList)
            } else {
                self?.loadEachCurrentWeatherAndSort(with: City.coordinateList)
            }
        }
    }
    
    private func loadEachCurrentWeatherAndSort(with loadCoordinateList: [Coordinate]) {
        loadCoordinateList.forEach({ (coordinate) in
            loadCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] (weather) in
                self?.currentWeatherList.removeAll(where: { currentWeather in
                    weather.cityName == currentWeather.cityName
                })
                self?.append(weather)
            }
        })
    }
    
    // MARK: - index 찾아서 정렬해봅시다
    
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        WeatherAPI.fetchWeather(APIType.currentWeather, latitude, longitude) { (result: Result<CurrentWeatherResponse, APIError>) in
            switch result {
            case .success(let currentWeatherResponse):
                guard let iconPath = currentWeatherResponse.additionalInformation.first?.iconPath,
                      let description = currentWeatherResponse.additionalInformation.first?.description else { return }
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeatherResponse.coordinate.latitude, longtitude: currentWeatherResponse.coordinate.longitude) { updateCityName in
                    let weather: CurrentWeather = CurrentWeather(coordinate: currentWeatherResponse.coordinate,
                                         cityName: updateCityName,
                                         icon: ImageManager.getImage(iconPath),
                                         description: description,
                                         humidity: currentWeatherResponse.weather.humidity,
                                         temperature: currentWeatherResponse.weather.temperature)
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
            self?.currentWeatherList.removeAll(where: { currentWeather in
                addWeather.cityName == currentWeather.cityName
            })
            self?.currentWeatherList.insert(addWeather, at: 0)
        }
    }
}
