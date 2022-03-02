//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit
import CoreLocation

protocol CurrentWeatherDataUpdatable: AnyObject {
    func update(currentWeather: HourlyWeather)
}

protocol HourlyWeatherListDataUpdatable: AnyObject {
    func update(hourlyWeatherList: [HourlyWeather])
}

protocol DailyWeatherListDataUpdatable: AnyObject {
    func update(dailyWeatherList: [DailyWeather])
}

protocol UserAddWeatherDataUpdatable: AnyObject {
    func add(coordinate: Coordinate)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var detailWeatherTableView: UITableView!
    var coord: Coordinate?
    var address: String?
    var addButtonIsOff: Bool = false
    weak var currentWeatherDelegate: CurrentWeatherDataUpdatable?
    weak var hourlyWeatherListDelegate: HourlyWeatherListDataUpdatable?
    weak var dailyWeatherListDelegate: DailyWeatherListDataUpdatable?
    weak var addWeatehrDelegate: UserAddWeatherDataUpdatable?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDetailTableView()
        setUpAddbutton()
        loadDetailWeather()
    }
    
    private func loadDetailWeather() {
        guard let coord = coord else { return }
        WeatherAPI.fetchWeather(APIType.dailyWeather, coord.latitude, coord.longitude) { [weak self] (result: Result<DetailWeather, APIError>) in
            switch result {
            case .success(let dailyWeatherData):
                self?.hourlyWeatherListDelegate?.update(hourlyWeatherList: dailyWeatherData.hourly)
                self?.dailyWeatherListDelegate?.update(dailyWeatherList: dailyWeatherData.daily)
                self?.currentWeatherDelegate?.update(currentWeather: dailyWeatherData.current)
                self?.updateWeather(data: dailyWeatherData.current)
                DispatchQueue.main.async {
                    self?.detailWeatherTableView.reloadData()
                }
            case .failure(let error):
                print("Detail View Networking Error: \(error.localizedDescription)")
            }
        }
        AddressManager.convertCityNameEnglishToKoreanSimply(latitude: coord.latitude, longtitude: coord.longitude) { [weak self] (adress) in
            self?.address = adress
        }
    }
    
    private func updateWeather(data: HourlyWeather) {
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = "\(data.temperature.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
            self?.feelsLikeTemperatureLabel.text = "\(data.feelsLike.oneDecimalPlaceInString) \(WeatherSymbols.temperature)"
            guard let address = self?.address else { return }
            self?.addressLabel.text = "\(address)"
        }
    }

    private func setUpAddbutton() {
        if addButtonIsOff {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    private func setUpDetailTableView() {
        registerHeaderView()
        registerTableViewCell()
    }
    
    private func registerHeaderView() {
        detailWeatherTableView.register(CurrentWeatherSectionHeaderView.nib(), forHeaderFooterViewReuseIdentifier: CurrentWeatherSectionHeaderView.identifier)
        
        detailWeatherTableView.register(HourlyWeatherSectionHeaderView.nib(), forHeaderFooterViewReuseIdentifier: HourlyWeatherSectionHeaderView.identifier)
        
        detailWeatherTableView.register(DailyWeatherSectionHeaderView.nib(), forHeaderFooterViewReuseIdentifier: DailyWeatherSectionHeaderView.identifier)
    }
    
    private func registerTableViewCell() {
        detailWeatherTableView.register(CurrentTableViewCell.nib(), forCellReuseIdentifier: CurrentTableViewCell.identifier)
        
        detailWeatherTableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        
        detailWeatherTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "즐겨 찾는 도시에 추가되었습니다.", message: "메인 화면으로 이동합니다.", preferredStyle: .alert)
        guard let coordinate = coord else { return }
        let mainViewController = presentingViewController?.presentingViewController as? MainViewController
        addWeatehrDelegate = mainViewController?.mainViewModel
        addWeatehrDelegate?.add(coordinate: coordinate)
        let settingAction = UIAlertAction(title: "확인", style: .default) { _ in
            mainViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(settingAction)
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentTableViewCell.identifier, for: indexPath) as? CurrentTableViewCell else { return UITableViewCell() }
            currentWeatherDelegate = cell
            cell.update()
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else { return UITableViewCell() }
            hourlyWeatherListDelegate = cell
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
            dailyWeatherListDelegate = cell
            return cell
        default: return UITableViewCell()
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurrentWeatherSectionHeaderView.identifier)
            return headerView
        case 1:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HourlyWeatherSectionHeaderView.identifier)
            return headerView
        case 2:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DailyWeatherSectionHeaderView.identifier)
            return headerView
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else if indexPath.section == 1 {
            return 140
        } else if indexPath.section == 2{
            return 370
        }
        return 0
    }
}
