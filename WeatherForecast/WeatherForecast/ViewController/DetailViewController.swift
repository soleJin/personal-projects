//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var detailWeatherTableView: UITableView!
    
    var detailViewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddButton()
        setUpDetailViewModel()
        setUpDetailTableView()
    }
    
    private func setUpDetailTableView() {
        registerHeaderView()
        registerTableViewCell()
    }
    
    private func registerHeaderView() {
        detailWeatherTableView.register(HourlyWeatherSectionHeaderView.nib(), forHeaderFooterViewReuseIdentifier: HourlyWeatherSectionHeaderView.identifier)
        
        detailWeatherTableView.register(DailyWeatherSectionHeaderView.nib(), forHeaderFooterViewReuseIdentifier: DailyWeatherSectionHeaderView.identifier)
    }
    
    private func registerTableViewCell() {
        detailWeatherTableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        
        detailWeatherTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)
    }
    
    private func setUpDetailViewModel() {
        detailViewModel.delegate = self
        detailViewModel.loadDetailWeather()
    }
    
    private func setUpAddButton() {
//        addButton.isHidden = true
    }
}

extension DetailViewController: DetailWeatherDataUpdatable {
    func updateUI(hourlyWeather: HourlyWeather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(hourlyWeather.temperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
            self.feelsLikeTemperatureLabel.text = "\(hourlyWeather.feelsLike.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
            self.pressureLabel.text = "\(hourlyWeather.pressure) \(WeatherSymbols.pressure)"
            self.humidityLabel.text = "\(hourlyWeather.humidity) \(WeatherSymbols.humidity)"
            self.windSpeedLabel.text = "\(hourlyWeather.windSpeed.toOneDecimalPlaceInString()) \(WeatherSymbols.windSpeed)"
            guard let address = self.detailViewModel.address else { return }
            self.addressLabel.text = "\(address)"
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.detailWeatherTableView.reloadData()
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
            return cell
        } 
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HourlyWeatherSectionHeaderView.identifier)
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DailyWeatherSectionHeaderView.identifier)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


