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
        loadEachCurrentWeather()
        setUpSearchBar()
        setUpButton()
        configureCurrentLocation()
        initRefresh()
    }
    
    private func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        cityTableView.refreshControl = refresh
    }
    
    @objc private func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        setUpButton()
        loadEachCurrentWeather()
    }
    
    private func setUpButton() {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
        cityNameButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        humidityButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        temperatureButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    private func loadEachCurrentWeather() {
        for cityName in CityName.nameList {
            self.loadCurrentWeather(cityName: cityName, latitude: nil, longtitude: nil) { weather in
                self.mainViewModel.currentWeatherList.removeAll(where: { (currentWeather) -> Bool in
                    currentWeather.cityName == weather.cityName
                })
                self.mainViewModel.append(weather)
            }
        }
    }
    
    private func loadCurrentWeather(cityName: String?, latitude: Double?, longtitude: Double?, completion: @escaping (CurrentWeather) -> Void) {
        WeatherAPI.fetchWeather(APIType.currentWeather, cityName, latitude, longtitude) { (result: Result<CurrentWeather, APIError>) in
            switch result {
            case .success(let currentWeather):
                var weather = currentWeather
                AddressManager.convertCityNameEnglishToKoreanSimply(latitude: currentWeather.coord.latitude, longtitude: currentWeather.coord.longitude) { [weak self] (updateCityName) in
                    weather.cityNameInKorean = updateCityName
                    DispatchQueue.main.async {
                        self?.cityTableView.reloadData()
                    }
                    completion(weather)
                }
            case .failure(let error):
                print(error.localizedDescription)
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
            switch sender {
            case cityNameButton:
                mainViewModel.descendingOrderCityNameInKorean()
            case humidityButton:
                mainViewModel.descendingOrderHumidity()
            case temperatureButton:
                mainViewModel.descendingOrderTemperature()
            default: break
            }
        } else {
            sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            switch sender {
            case cityNameButton:
                mainViewModel.ascendingOrderCityNameInKorean()
            case humidityButton:
                mainViewModel.ascendingOrderHumidity()
            case temperatureButton:
                mainViewModel.ascendingOrderTemperature()
            default: break
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
        guard let cityName = searchBar.text else { return }
        searchBar.text = "\(cityName) 조회중.."
        searchBar.searchTextField.textColor = .systemYellow
        loadCurrentWeather(cityName: cityName, latitude: nil, longtitude: nil) { [weak self] weather in
            self?.mainViewModel.currentWeatherList.removeAll { (currentWeather) -> Bool in
                cityName == currentWeather.cityName
            }
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
        if searchText == "" {
            cityTableView.reloadData()
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    private func configureCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        loadCurrentWeather(cityName: nil, latitude: location.coordinate.latitude, longtitude: location.coordinate.longitude) { [weak self] weather in
            self?.mainViewModel.locationWeather = weather
            DispatchQueue.main.async {
                self?.updateCurrentLocationUI(weather: weather)
            }
        }
    }
    
    private func updateCurrentLocationUI(weather: CurrentWeather) {
        addressLabel.text = weather.cityNameInKorean
        temperatureLabel.text = "\(round(weather.weather.temperature*10/10)) \(WeatherSymbols.temperature)"
        guard let iconPath = weather.additionalInformation.first?.iconPath,
              let weatherDescription = weather.additionalInformation.first?.description else { return }
        descriptionLabel.text = weatherDescription
        ImageManager.getImage(iconPath) { (icon) in
            self.weatherIconImageView.image = icon
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            promptForAuthorization()
            loadCurrentWeather(cityName: nil, latitude: 37.62746, longtitude: 126.98547) { [weak self] weather in
                self?.mainViewModel.locationWeather = weather
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
    
    private func promptForAuthorization() {
        let alert = UIAlertController(title: "현재 위치의 날씨정보를\n조회하기 위해\n위치접근 허용이 필요합니다.", message: "위치접근을 허용해주세요!", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _IOFBF in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel , handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        alert.preferredAction = settingsAction
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailError \(error.localizedDescription)")
    }
}
