//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var temeratureSegmentControl: UISegmentedControl!
    var mainViewModel = MainViewModel()
    var temperatureUnit: TemperatureUnit = .C
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEachCurrentWeather()
        temeratureSegmentControl.selectedSegmentIndex = 1
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
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            guard temperatureUnit == .C else { return }
            temperatureUnit = .F
            mainViewModel.convertTemperatureUnitCtoF()
            cityTableView.reloadData()
        } else {
            guard temperatureUnit == .F else { return }
            temperatureUnit = .C
            mainViewModel.convertTemperatureUnitFtoC()
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
        cell.update(data: mainViewModel.sortedWeather(at: indexPath.row))
        return cell
    }
}
