//
//  CityListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

class CityListCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIImageView!

    override func prepareForReuse() {
        cityNameLabel.text = nil
        currentTemperatureLabel.text = nil
        currentWeatherIcon.image = nil
        currentHumidityLabel.text = nil
    }
    
    func update(weather: CurrentWeather) {
        setUpCellBackgroundView()
        cityNameLabel.text = weather.cityName
        currentWeatherIcon.image = weather.icon
        currentHumidityLabel.text = "\(weather.humidity) \(WeatherSymbols.humidity)"
        currentTemperatureLabel.text = "\(weather.temperature.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
    }
    
    private func setUpCellBackgroundView() {
        cellBackgroundView.layer.cornerRadius = 3
        cellBackgroundView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cellBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 1
    }
}
