//
//  CurrentWeatherSectionHeaderView.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/13.
//

import UIKit

class CurrentWeatherSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CurrentWeatherSectionHeaderView"
    static func nib() -> UINib {
        return UINib(nibName: CurrentWeatherSectionHeaderView.identifier, bundle: nil)
    }
}
