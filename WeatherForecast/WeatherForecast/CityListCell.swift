//
//  CityListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

class CityListCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!

    override func prepareForReuse() {
        cityNameLabel.text = nil
        weatherIconImageView.image = nil
        currentHumidityLabel.text = nil
        currentTemperatureLabel.text = nil
    }
}
