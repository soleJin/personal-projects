//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var temeratureSegmentControl: UISegmentedControl!
    @IBOutlet weak var cityNameButton: UIButton!
    @IBOutlet weak var humidityButton: UIButton!
    @IBOutlet weak var temperatureButton: UIButton!
    @IBOutlet weak var cityTableView: UITableView!

    var mainViewModel = MainViewModel()
    var temperatureUnit: TemperatureUnit = .C
    let locationManager = CLLocationManager()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temeratureSegmentControl.selectedSegmentIndex = 1
//        configureCurrentLocationWeather()
        loadEachCurrentWeather()
        setUpSearchBar()
        initRefresh()
        setUpButton()
    }
    
    private func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        cityTableView.refreshControl = refresh
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        mainViewModel.currentWeatherList.sort {( $0.cityName < $1.cityName )}
        setUpButton()
        cityTableView.reloadData()
    }
    
    private func setUpButton() {
        setUpButtonColor()
        cityNameButton.tintColor = .black
        cityNameButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    private func setUpButtonColor() {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
    }
    
    private func loadEachCurrentWeather() {
        for cityName in CityName.nameList {
            WeatherAPI.fetchWeather(APIType.currentWeather, cityName, nil) { [weak self](currentWeather: CurrentWeather) in
                var weather = currentWeather
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeather.coord.latitude, longtitude: currentWeather.coord.longitude) { (updateCityName) in
                    weather.cityName = updateCityName
                    self?.mainViewModel.append(weather)
                    self?.mainViewModel.currentWeatherList.sort {( $0.cityName < $1.cityName )}
                    DispatchQueue.main.async {
                        self?.cityTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setUpSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.tintColor = .darkGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "도시 이름을 검색하세요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    
    @IBAction func tapLabelButton(_ sender: UIButton) {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
        sender.tintColor = .black
        
        if sender.currentImage == UIImage(systemName: "chevron.up") {
            sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            if sender == cityNameButton {
                mainViewModel.descendingOrderCityName()
            } else if sender == humidityButton {
                mainViewModel.descendingOrderHumidity()
            } else {
                mainViewModel.descendingOrderTemperature()
            }
        } else {
            sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            if sender == cityNameButton {
                mainViewModel.ascendingOrderCityName()
            } else if sender == humidityButton {
                mainViewModel.ascendingOrderHumidity()
            } else {
                mainViewModel.ascendingOrderTemperature()
            }
        }
        cityTableView.reloadData()
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            guard temperatureUnit == .C else { return }
            temperatureUnit = .F
            mainViewModel.convertTemperatureUnitCtoF {
                temperatureLabel.text = "\(round(mainViewModel.locationTemperature*10)/10) \(WeatherSymbols.temperature)"
            }
            cityTableView.reloadData()
        } else {
            guard temperatureUnit == .F else { return }
            temperatureUnit = .C
            mainViewModel.convertTemperatureUnitFtoC {
                temperatureLabel.text = "\(round(mainViewModel.locationTemperature*10)/10) \(WeatherSymbols.temperature)"
            }
            cityTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.numberOfCurrentWeatherList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCell", for: indexPath) as? CityListCell else { return UITableViewCell() }
        cell.update(data: mainViewModel.currentWeather(at: indexPath.row))
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let cityName = searchBar.text else { return }
        WeatherAPI.fetchWeather(APIType.currentWeather, cityName, nil) { [weak self](currentWeather: CurrentWeather) in
            var weather = currentWeather
            AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeather.coord.latitude, longtitude: currentWeather.coord.longitude) { (updateCityName) in
                weather.cityName = updateCityName
                self?.mainViewModel.currentWeatherList.removeAll { (currentWeather) -> Bool in
                    cityName == currentWeather.cityName
                }
                self?.mainViewModel.append(weather)
                DispatchQueue.main.async {
                    self?.cityTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            cityTableView.reloadData()
        }
    }
}

