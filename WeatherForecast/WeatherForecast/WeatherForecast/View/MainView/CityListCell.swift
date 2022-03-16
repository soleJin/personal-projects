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
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
        }
        ImageManager.getImage(weather.iconPath) { icon in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.currentWeatherIcon.image = icon
            }
        }
        currentHumidityLabel.text = "\(weather.humidity) \(WeatherSymbols.humidity)"
        if let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String,
           temperatureUnit == TemperatureUnit.fahrenheit.rawValue {
            currentTemperatureLabel.text = "\(weather.temperature.inFahrenheit.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        } else {
            currentTemperatureLabel.text = "\(weather.temperature.inCelsius.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        }
    }
    
    private func setUpCellBackgroundView() {
        cellBackgroundView.layer.cornerRadius = 3
        cellBackgroundView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cellBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 1
    }
}
