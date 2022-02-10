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
        dump("===================viewdidload=========\(coord)")
        guard let coord = coord else { return }
        WeatherAPI.fetchWeather(APIType.dailyWeather, nil, coord.latitude, coord.longitude) { (result: Result<DetailWeather, APIError>) in
            switch result {
            case .success(let dailyWeatherData):
                self.currentWeather = dailyWeatherData.current
                self.hourlyWeatherList = dailyWeatherData.hourly
                self.dailyWeatherList = dailyWeatherData.daily
                guard let current = self.currentWeather else { return }
                DispatchQueue.main.async {
                    self.temperatureLabel.text = "\(round(current.temperature*10)/10) \(WeatherSymbols.temperature)"
                    self.feelsLikeTemperatureLabel.text = "\(round(current.feelsLike*10)/10) \(WeatherSymbols.temperature)"
                    self.pressureLabel.text = "\(current.pressure) \(WeatherSymbols.pressure)"
                    self.humidityLabel.text = "\(current.humidity) \(WeatherSymbols.humidity)"
                    self.windSpeedLabel.text = "\(round(current.windSpeed*10)/10) \(WeatherSymbols.windSpeed)"
                    self.hourlyCollectionView.reloadData()
                    self.dailyTableView.reloadData()
                }
            case .failure(let error):
                print("--------Error--------\(error.localizedDescription)")
            }
        }
        AddressManager.convertCityNameEnglishToKoreanInDetail(latitude: coord.latitude, longtitude: coord.longitude) { (adress) in
            self.addressLabel.text = adress
        }
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

