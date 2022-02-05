//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
//import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var temeratureSegmentControl: UISegmentedControl!
    
    var mainViewModel = MainViewModel()
    var temperatureUnit: TemperatureUnit = .C
//    let locationManager = CLLocationManager()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temeratureSegmentControl.selectedSegmentIndex = 1
//        configureCurrentLocationWeather()
        loadEachCurrentWeather()
        setUpSearchBar()
    }
    
    private func loadEachCurrentWeather() {
        for cityName in CityName.nameList {
            WeatherAPI.fetchWeather(APIType.currentWeather, cityName, nil) { [weak self](currentWeather: CurrentWeather) in
                self?.mainViewModel.append(currentWeather)
                DispatchQueue.main.async {
                    self?.cityTableView.reloadData()
                }
            }
        }
    }
    
    private func setUpSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.darkGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "도시 이름을 검색하세요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            guard temperatureUnit == .C else { return }
            temperatureUnit = .F
            mainViewModel.convertTemperatureUnitCtoF()
            cityTableView.reloadData()
            temperatureLabel.text = temperatureLabel.text?.convertTemperatureUnitFtoCString()
        } else {
            guard temperatureUnit == .F else { return }
            temperatureUnit = .C
            mainViewModel.convertTemperatureUnitFtoC()
            cityTableView.reloadData()
            temperatureLabel.text = temperatureLabel.text?.convertTemperatureUnitCtoFString()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.numberOfCurrentWeatherList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCell", for: indexPath) as? CityListCell else { return UITableViewCell() }
        cell.update(data: mainViewModel.sortedWeather(at: indexPath.row))
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let cityName = searchBar.text else { return }
        WeatherAPI.fetchWeather(APIType.currentWeather, cityName, nil) { [weak self] (currentWeather: CurrentWeather) in
            self?.mainViewModel.currentWeatherList = []
            self?.mainViewModel.append(currentWeather)
            DispatchQueue.main.async {
                self?.cityTableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        mainViewModel.currentWeatherList = []
        loadEachCurrentWeather()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            mainViewModel.currentWeatherList = []
            loadEachCurrentWeather()
        }
    }
}
