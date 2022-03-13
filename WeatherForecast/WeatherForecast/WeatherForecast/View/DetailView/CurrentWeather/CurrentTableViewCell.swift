//
//  CurrentTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/13.
//

import UIKit

final class CurrentTableViewCell: UITableViewCell {
    static let identifier = "CurrentTableViewCell"
    var currentWeather: HourlyWeather?
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: CurrentTableViewCell.identifier, bundle: nil)
    }
    
    func update() {
        guard let currentWeather = currentWeather else { return }
        guard let sunrise = currentWeather.sunrise,
              let sunset = currentWeather.sunset else { return }
        sunriseLabel.text = sunrise.convertToDateString(TimeUnit.minutely)
        sunsetLabel.text = sunset.convertToDateString(TimeUnit.minutely)
        weatherDescriptionLabel.text = currentWeather.weatherDescription
        humidityLabel.text = "\(currentWeather.humidity) \(WeatherSymbols.humidity)"
        pressureLabel.text = "\(currentWeather.pressure) \(WeatherSymbols.pressure)"
        windSpeed.text = "\(currentWeather.windSpeed) \(WeatherSymbols.windSpeed)"
    }
}

extension CurrentTableViewCell: CurrentWeatherDataUpdatable {
    func update(currentWeather: HourlyWeather) {
        self.currentWeather = currentWeather
    }
}
