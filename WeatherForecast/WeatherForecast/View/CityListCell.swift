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
        cityNameLabel.text = data.cityName
        guard let temperature = data.weather?.temperature,
           let humidity = data.weather?.humidity,
           let iconPath = data.additionalInformation?.first?.iconPath else { return }
        currentWeatherIcon.image = UIImage(named: iconPath)
        currentHumidityLabel.text = "\(humidity)%"
        currentTemperatureLabel.text = "\(round((temperature-273.15)*10)/10)º"
    }
}
