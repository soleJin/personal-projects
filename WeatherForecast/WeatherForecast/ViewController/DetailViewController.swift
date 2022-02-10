//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var coord: Coordinate? = nil
    var currentWeather: HourlyWeather? = nil
    var hourlyWeatherList = [HourlyWeather]()
    var dailyWeatherList = [DailyWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(coord)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyGridCell", for: indexPath) as? HourlyGridCell else { return UICollectionViewCell() }
        cell.update(data: hourlyWeatherList[indexPath.item])
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 130)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListCell", for: indexPath) as? DailyListCell else { return UITableViewCell() }
        cell.update(data: dailyWeatherList[indexPath.row])
        return cell
    }
}


