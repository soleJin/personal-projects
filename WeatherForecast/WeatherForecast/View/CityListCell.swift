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

    override func prepareForReuse() {
        cityNameLabel.text = nil
        currentTemperatureLabel.text = nil
        currentWeatherIcon.image = nil
        currentHumidityLabel.text = nil
    }
    
    func update(data: CurrentWeather) {
        cityNameLabel.text = data.cityNameInKorean
        if data.cityNameInKorean == nil {
            cityNameLabel.text = data.cityName
        }
        currentWeatherIcon.image = data.weatherIcon
        currentHumidityLabel.text = "\(data.weather.humidity) \(WeatherSymbols.humidity)"
        currentTemperatureLabel.text = "\(data.weather.temperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
    }
}
