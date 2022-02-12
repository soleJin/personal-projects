//
//  DetailTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    static let identifier = "DetailTableViewCell"
    static func nib() ->UINib {
        return UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
    }
}
