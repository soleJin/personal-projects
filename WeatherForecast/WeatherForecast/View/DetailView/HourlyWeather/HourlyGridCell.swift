//
//  HourlyGridCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class HourlyGridCell: UICollectionViewCell {
    static let identifier = "HourlyGridCell"
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var hourlyTimeLabel: UILabel!
    @IBOutlet weak var hourlyTemperatureLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: HourlyGridCell.identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        weatherIcon.image = nil
        hourlyTimeLabel.text = nil
        hourlyTemperatureLabel.text = nil
    }
    
    func update(data: HourlyWeather) {
        weatherIcon.image = data.icon
        hourlyTimeLabel.text = data.dateTime.convertToDateString(TimeUnit.hourly)
        hourlyTemperatureLabel.text = "\(data.temperature.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
    }
}
