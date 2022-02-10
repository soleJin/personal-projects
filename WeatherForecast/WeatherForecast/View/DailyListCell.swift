//
//  DailyListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/10.
//

import UIKit

class DailyListCell: UITableViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    
    override func prepareForReuse() {
        weatherIcon.image = nil
        dayLabel.text = nil
        maximumTemperatureLabel.text = nil
        minimumTemperatureLabel.text = nil
    }
    
    func update(data: DailyWeather) {
        weatherIcon.image = data.icon
        dayLabel.text = data.dateTime.convertToDailyString()
        maximumTemperatureLabel.text = "\(round(data.temperature.maximum*10)/10) \(WeatherSymbols.temperature)"
        minimumTemperatureLabel.text = "\(round(data.temperature.minimum*10)/10) \(WeatherSymbols.temperature)"
    }
    
}
