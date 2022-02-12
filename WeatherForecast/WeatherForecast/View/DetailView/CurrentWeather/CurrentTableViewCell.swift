//
//  CurrentTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/13.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {
    static let identifier = "CurrentTableViewCell"
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: CurrentTableViewCell.identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        sunriseLabel.text = nil
        sunsetLabel.text = nil
        weatherDescriptionLabel.text = nil
        humidityLabel.text = nil
        pressureLabel.text = nil
        windSpeed.text = nil
    }
    
    func update(data: HourlyWeather) {
        guard let sunrise = data.sunrise,
              let sunset = data.sunset else { return }
        sunriseLabel.text = sunrise.convertToDateString(TimeUnit.minutely)
        sunsetLabel.text = sunset.convertToDateString(TimeUnit.minutely)
        weatherDescriptionLabel.text = data.weatherDescription
        humidityLabel.text = "\(data.humidity) \(WeatherSymbols.humidity)"
        pressureLabel.text = "\(data.pressure) \(WeatherSymbols.pressure)"
        windSpeed.text = "\(data.windSpeed) \(WeatherSymbols.windSpeed)"
    }
}
