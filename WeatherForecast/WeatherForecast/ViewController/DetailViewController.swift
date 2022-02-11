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
    }
    
    private func setUpDetailViewModel() {
        detailViewModel.delegate = self
        detailViewModel.loadDetailWeather()
    }
    
    private func setUpAddButton() {
        addButton.isHidden = true
        addButton.layer.cornerRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        addButton.layer.shadowColor = UIColor.darkGray.cgColor
        addButton.layer.shadowOpacity = 1
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
        //
    }
}


