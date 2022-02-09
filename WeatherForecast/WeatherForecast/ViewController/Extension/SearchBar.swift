//
//  ExtensionSearchBar.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

extension MainViewController: UISearchBarDelegate, SendErrorMessage {
    func sendErrorMessage() {
        DispatchQueue.main.async {
            self.present(AlertManager.promptForWrongCityName(), animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        WeatherAPI.delegate = self
        guard let cityName = searchBar.text else { return }
        searchBar.searchTextField.textColor = .systemYellow
        mainViewModel.loadCurrentWeather(cityName: cityName, latitude: nil, longtitude: nil) { [weak self ](weather) in
            self?.mainViewModel.currentWeatherList.removeAll(where: { (currentWeather) -> Bool in
                currentWeather.cityName == weather.cityName
            })
            self?.mainViewModel.currentWeatherList.insert(weather, at: 0)
            searchBar.text = nil
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.searchTextField.textColor = .systemYellow
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
}
