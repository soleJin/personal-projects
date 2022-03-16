//
//  DailyListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

final class DailyListCell: UITableViewCell {
    static let identifier = "DailyListCell"
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: DailyListCell.identifier, bundle: nil)
    }

    override func prepareForReuse() {
        weatherIcon.image = nil
        dayLabel.text = nil
        maximumTemperatureLabel.text = nil
        minimumTemperatureLabel.text = nil
    }
    
    func update(data: DailyWeather) {
        ImageManager.getImage(data.iconPath) { [weak self] icon in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.weatherIcon.image = icon
            }
        }
        dayLabel.text = data.dateTime.convertToDateString(TimeUnit.daily)
        if let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String,
           temperatureUnit == TemperatureUnit.fahrenheit.rawValue {
            maximumTemperatureLabel.text = "\(data.temperature.maximum.inFahrenheit.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
            minimumTemperatureLabel.text = "\(data.temperature.minimum.inFahrenheit.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        } else {
            maximumTemperatureLabel.text = "\(data.temperature.maximum.inCelsius.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
            minimumTemperatureLabel.text = "\(data.temperature.minimum.inCelsius.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        }
    }
}
