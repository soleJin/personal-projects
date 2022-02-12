//
//  HourlyTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: HourlyTableViewCell.identifier, bundle: nil)
    }
}
