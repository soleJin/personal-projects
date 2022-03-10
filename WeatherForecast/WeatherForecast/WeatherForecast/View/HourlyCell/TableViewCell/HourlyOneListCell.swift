//
//  HourlyOneListCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/10.
//

import UIKit

class HourlyOneListCell: UITableViewCell {
    static let identifier = "HourlyOneListCell"
    let weatherList = [
        HourlyWeather(dt: 1200394, temp: 3.0, pressure: 32, humidity: 47, wind_speed: 3.4, weather: [Weather(description: "맑음", iconPath:"03d")]),
        HourlyWeather(dt: 1200394, temp: 3.0, pressure: 32, humidity: 47, wind_speed: 3.4, weather: [Weather(description: "맑음", iconPath:"03d")]),
        HourlyWeather(dt: 1200394, temp: 3.0, pressure: 32, humidity: 47, wind_speed: 3.4, weather: [Weather(description: "맑음", iconPath:"03d")]),
        HourlyWeather(dt: 1200394, temp: 3.0, pressure: 32, humidity: 47, wind_speed: 3.4, weather: [Weather(description: "맑음", iconPath:"03d")]),
        HourlyWeather(dt: 1200394, temp: 3.0, pressure: 32, humidity: 47, wind_speed: 3.4, weather: [Weather(description: "맑음", iconPath:"03d")])
    ]
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyOneListCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        hourlyCollectionView.register(HourlyGridCell.nib(), forCellWithReuseIdentifier: HourlyGridCell.identifier)
        hourlyCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HourlyOneListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyGridCell.identifier, for: indexPath) as? HourlyGridCell else { return UICollectionViewCell() }
        let weather = weatherList[indexPath.row]
        cell.update(data: weather)
        return cell
    }
}

extension HourlyOneListCell: UICollectionViewDelegateFlowLayout {
    
}
