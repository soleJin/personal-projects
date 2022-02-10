//
//  HourlyGridCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/10.
//

import UIKit

class HourlyGridCell: UICollectionViewCell {
    static let identifier = "HourlyGridCell"
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var hourlyTimeLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyGridCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        weatherIcon.image = nil
        hourlyTimeLabel.text = nil
    }
    
    func update(data: HourlyWeather) {
        weatherIcon.image = data.icon
        hourlyTimeLabel.text = data.dt.convertToHourlyString()
    }
}
