//
//  HourlyGirdCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/10.
//

import UIKit

class HourlyGirdCell: UICollectionViewCell {
    static let identifier = "HourlyGirdCell"
    @IBOutlet weak var hourlyTimeLabel: UILabel!
    @IBOutlet weak var hourlyIcon: UIImageView!
    
    override func prepareForReuse() {
        hourlyTimeLabel.text = nil
        hourlyIcon.image = nil
    }
    
    func update(data: HourlyWeather) {
        hourlyTimeLabel.text = data.dt.convertToHourlyString()
        hourlyIcon.image = data.icon
    }
}
