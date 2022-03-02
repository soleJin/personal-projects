//
//  DailyListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class DailyListCell: UITableViewCell {
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
        weatherIcon.image = data.icon
        dayLabel.text = data.dateTime.convertToDateString(TimeUnit.daily)
        maximumTemperatureLabel.text = "\(data.temperature.maximum.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
        minimumTemperatureLabel.text = "\(data.temperature.minimum.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
    }
}
