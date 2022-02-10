//
//  HourlyGridCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/10.
//

import UIKit

class HourlyGridCell: UICollectionViewCell {
    
    @IBOutlet weak var hourlyTimeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var hourlyTemperatureLable: UILabel!
    
    override func prepareForReuse() {
        weatherIcon.image = nil
        hourlyTimeLabel.text = nil
        hourlyTemperatureLable.text = nil
    }
    
    func update(data: HourlyWeather) {
        weatherIcon.image = data.icon
        hourlyTimeLabel.text = data.dt.convertToHourlyString()
        hourlyTemperatureLable.text = "\(round(data.temp*10)/10) \(WeatherSymbols.temperature)"
    }
}
