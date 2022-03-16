//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation
import MapKit

protocol CurrentWeatherListDataUpdatable: AnyObject {
    func mainTableViewReloadData()
} 

final class MainViewModel {
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
        let coordinateList = getCoordinateList()
        let coordinateDictionary = getinDictionary(with: coordinateList)
        coordinateList.forEach { [weak self] coordinate in
            guard let weakSelf = self else { return }
            weakSelf.loadCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { loadWeather in
                weakSelf.currentWeatherList.removeAll(where: { currentWeather in
                    loadWeather.cityName == currentWeather.cityName
                })
                var customWeather = loadWeather
                guard let findIndex = coordinateDictionary.findKey(for: loadWeather.coordinate) else { return }
                customWeather.index = findIndex
                DispatchQueue(label: "serial").sync {
                    weakSelf.append(customWeather)
                    weakSelf.currentWeatherList.sort { $0.index < $1.index }
                }
            }
        }
    }
    
    private func getCoordinateList() -> [Coordinate] {
        var coordinateList = [Coordinate]()
        if let userCoordinateList = UserDefaults.standard.loadCoordinateList() {
            coordinateList = userCoordinateList
        } else {
            coordinateList = City.coordinateList
        }
        return coordinateList
    }
    
    private func getinDictionary(with coordinateList: [Coordinate]) -> [Int: Coordinate] {
        var coordinateDictionary = [Int: Coordinate]()
        var count = 0
        for coordinate in coordinateList {
            coordinateDictionary.updateValue(coordinate, forKey: count)
            count += 1
        }
        return coordinateDictionary
    }
    
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        WeatherAPI.fetchWeather(APIType.currentWeather, latitude, longitude) { (result: Result<CurrentWeatherResponse, APIError>) in
            switch result {
            case .success(let currentWeatherResponse):
                guard let iconPath = currentWeatherResponse.additionalInformation.first?.iconPath,
                      let description = currentWeatherResponse.additionalInformation.first?.description else { return }
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeatherResponse.coordinate.latitude, longtitude: currentWeatherResponse.coordinate.longitude) { updateCityName in
                    let weather: CurrentWeather = CurrentWeather(coordinate: currentWeatherResponse.coordinate,
                                         cityName: updateCityName,
                                         iconPath: iconPath,
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
            guard let weakSelf = self else { return }
            weakSelf.currentWeatherList.removeAll(where: { currentWeather in
                addWeather.cityName == currentWeather.cityName
            })
            weakSelf.currentWeatherList.insert(addWeather, at: 0)
        }
    }
}
