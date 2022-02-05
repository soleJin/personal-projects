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
        guard let iconPath = data.additionalInformation.first?.iconPath else { return }
        ImageManager.getImage(iconPath, completion: { icon in
            self.currentWeatherIcon.image = icon
        })
        currentHumidityLabel.text = "\(data.weather.humidity) \(WeatherSymbols.humidity)"
        currentTemperatureLabel.text = "\(round(data.weather.temperature*10)/10) \(WeatherSymbols.temperature)"
    }
}
