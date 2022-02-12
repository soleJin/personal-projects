//
//  HourlyTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    static let identifier = "HourlyTableViewCell"
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    var hourlyWeatherList = [HourlyWeather]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hourlyCollectionView.register(HourlyGridCell.nib(), forCellWithReuseIdentifier: HourlyGridCell.identifier)
        hourlyCollectionView.dataSource = self
    }
    
    static func nib() -> UINib {
        return UINib(nibName: HourlyTableViewCell.identifier, bundle: nil)
    }
    
    func update(_ hourlyWeatherList: [HourlyWeather]) {
        self.hourlyWeatherList = hourlyWeatherList
        hourlyCollectionView.reloadData()
    }
}

extension HourlyTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyGridCell.identifier, for: indexPath) as? HourlyGridCell else { return UICollectionViewCell() }
        cell.update(data: hourlyWeatherList[indexPath.item])
        return cell
    }
}
