//
//  SectionHeaderView.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

final class DailyWeatherSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "DailyWeatherSectionHeaderView"
    static func nib() -> UINib {
        return UINib(nibName: DailyWeatherSectionHeaderView.identifier, bundle: nil)
    }
}
