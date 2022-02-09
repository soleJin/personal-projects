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
        mainViewModel.delegate = self
        temeratureSegmentControl.selectedSegmentIndex = 1
        mainViewModel.loadEachCurrentWeather()
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
//        loadEachCurrentWeather()
    }
    
    private func setUpButton() {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
        cityNameButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        humidityButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        temperatureButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
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
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            guard temperatureUnit == .C else { return }
            temperatureUnit = .F
            mainViewModel.convertTemperatureUnitCtoF {
                temperatureLabel.text = "\(round(mainViewModel.locationTemperature*10)/10) \(WeatherSymbols.temperature)"
            }
        } else {
            guard temperatureUnit == .F else { return }
            temperatureUnit = .C
            mainViewModel.convertTemperatureUnitFtoC {
                temperatureLabel.text = "\(round(mainViewModel.locationTemperature*10)/10) \(WeatherSymbols.temperature)"
            }
        }
        DispatchQueue.main.async {
            self.cityTableView.reloadData()
        }
    }
}

extension MainViewController: DataUpdatable {
    func reloadData() {
        DispatchQueue.main.async {
            self.cityTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainViewModel.delete(at: indexPath.row)
            cityTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}
