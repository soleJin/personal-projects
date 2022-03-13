//
//  GridSectionHeaderView.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

final class HourlyWeatherSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "HourlyWeatherSectionHeaderView"
    static func nib() -> UINib {
        return UINib(nibName: HourlyWeatherSectionHeaderView.identifier, bundle: nil)
    }
}
