//
//  SearchListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/13.
//

import UIKit

class SearchListCell: UITableViewCell {
    static let identifier = "SearchListCell"
    @IBOutlet weak var titleLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: SearchListCell.identifier, bundle: nil)
    }
}
