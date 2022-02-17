//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var detailWeatherTableView: UITableView!
    var detailViewModel = DetailViewModel()
    var addButtonIsOff: Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDetailViewModel()
        setUpDetailTableView()
        setUpAddbutton()
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
    
    private func setUpDetailViewModel() {
        detailViewModel.delegate = self
        detailViewModel.loadDetailWeather()
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "즐겨 찾는 도시에 추가되었습니다.", message: "메인 화면으로 이동합니다.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let mainViewController = self?.storyboard?.instantiateViewController(withIdentifier: "MainView") as? MainViewController else { return }
            mainViewController.mainViewModel.loadCurrentWeather(cityName: nil, latitude: self?.detailViewModel.coord?.latitude, longtitude: self?.detailViewModel.coord?.longitude) { weather in
                mainViewController.mainViewModel.append(weather)
            }
            self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(settingAction)
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: DetailWeatherDataUpdatable {
    func updateWeather(data: HourlyWeather) {
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = "\(data.temperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
            self?.feelsLikeTemperatureLabel.text = "\(data.feelsLike.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
            guard let address = self?.detailViewModel.address else { return }
            self?.addressLabel.text = "\(address)"
        }
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.detailWeatherTableView.reloadData()
        }
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
            if let currentWeather = detailViewModel.currnetWeather {
                cell.update(data: currentWeather)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else { return UITableViewCell() }
            cell.update(detailViewModel.hourlyWeatherList)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
            cell.update(detailViewModel.dailyWeatherList)
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
