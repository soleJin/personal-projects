//
//  DetailTableHeaderView.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class DetailTableHeaderView: UITableViewHeaderFooterView {
    static let identifier = "DetailTableHeaderView"
    @IBOutlet weak var dailyWeatherCollectionView: UICollectionView!
    var hourlyWeatherList = [HourlyWeather]()
    
    static func nib() -> UINib {
        return UINib(nibName: DetailTableHeaderView.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dailyWeatherCollectionView.register(HourlyGridCell.nib(), forCellWithReuseIdentifier: HourlyGridCell.identifier)
        dailyWeatherCollectionView.dataSource = self
    }
}

//let layout = UICollectionViewFlowLayout()
//layout.scrollDirection = .horizontal

extension DetailTableHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyGridCell.identifier, for: indexPath) as? HourlyGridCell else { return UICollectionViewCell() }
        cell.update(data: hourlyWeatherList[indexPath.item])
        return cell
    }
}

extension DetailTableHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 130)
    }
}

extension DetailTableHeaderView: HourlyWeatherListDataUpdatable {
    func update(hourlyWeatherList: [HourlyWeather]) {
        self.hourlyWeatherList = hourlyWeatherList
    }
}
