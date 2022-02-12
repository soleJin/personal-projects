//
//  DetailTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class DetailHOurlyTableViewCell: UITableViewCell {
    static let identifier = "DetailHOurlyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: DetailHOurlyTableViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
