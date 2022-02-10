//
//  HourlyCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/10.
//

import UIKit


class HourlyOneListCell: UITableViewCell {
    
}

class HourlyGridCell: UICollectionViewCell {
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
