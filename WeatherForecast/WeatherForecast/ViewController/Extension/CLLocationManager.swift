//
//  ExtensionCLLocationManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case locationManagerDidFail
    case locationAuthorizationDenied
    
    var errorDescription: String {
        switch self {
        case .locationManagerDidFail:
            return "현재 위치를 불러오지 못했습니다. 잡시 후 다시 시도해주세요"
        case .locationAuthorizationDenied:
            return "위치정보를 비활성화하면 현재 위치를 알 수 없어요."
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func setUpCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        mainViewModel.loadCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self](weather) in
            self?.mainViewModel.locationWeather = weather
            DispatchQueue.main.async {
                self?.updateCurrentLocationUI(weather: weather)
            }
        }
    }
    
    private func updateCurrentLocationUI(weather: CurrentWeather) {
        addressLabel.text = weather.cityName
        if let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String,
           temperatureUnit == TemperatureUnit.fahrenheit.rawValue {
            temperatureLabel.text = "\(weather.temperature.inFahrenheit.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        } else {
            temperatureLabel.text = "\(weather.temperature.inCelsius.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        }
        descriptionLabel.text = weather.description
        self.weatherIconImageView.image = weather.icon
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            present(AlertManager.promptForAuthorization(), animated: true, completion: nil)
            mainViewModel.loadCurrentWeather(latitude: InitialLocation.latitude, longitude: InitialLocation.longtitude) { [weak self] (weather) in
                DispatchQueue.main.async {
                    self?.updateCurrentLocationUI(weather: weather)
                }
            }
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            locationManager.startUpdatingLocation()
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailError \(error.localizedDescription)")
    }
}
