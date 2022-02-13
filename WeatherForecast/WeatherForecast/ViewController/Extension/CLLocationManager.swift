//
//  ExtensionCLLocationManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import Foundation
import CoreLocation

extension MainViewController: CLLocationManagerDelegate {
    func configureCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        mainViewModel.loadCurrentWeather(cityName: nil, latitude: location.coordinate.latitude, longtitude: location.coordinate.longitude) { [weak self](weather) in
            self?.mainViewModel.locationWeather = weather
            DispatchQueue.main.async {
                self?.updateCurrentLocationUI(weather: weather)
            }
        }
    }
    
    private func updateCurrentLocationUI(weather: CurrentWeather) {
        addressLabel.text = weather.cityNameInKorean
        temperatureLabel.text = "\(weather.weather.temperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
        descriptionLabel.text = weather.weatherDescription
        self.weatherIconImageView.image = weather.weatherIcon
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            present(AlertManager.promptForAuthorization(), animated: true, completion: nil)
            mainViewModel.loadCurrentWeather(cityName: nil, latitude: InitialLocation.latitude, longtitude: InitialLocation.longtitude) { [weak self] (weather) in
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
