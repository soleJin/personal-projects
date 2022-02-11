//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureSegmentControl: UISegmentedControl!
    @IBOutlet weak var cityNameButton: UIButton!
    @IBOutlet weak var humidityButton: UIButton!
    @IBOutlet weak var temperatureButton: UIButton!
    @IBOutlet weak var cityTableView: UITableView!
    var mainViewModel = MainViewModel()
    let locationManager = CLLocationManager()
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as? DetailViewController
        if segue.identifier == "showDetailInCell",
              let location = sender as? Coordinate {
            detailViewController?.detailViewModel.coord = location
        }
        if segue.identifier == "showDetailInButton" {
            detailViewController?.detailViewModel.coord = mainViewModel.locationWeather?.coordinate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureSegmentControl.selectedSegmentIndex = 1
        setUpSerachButton()
        setUpMainViewModel()
        setUpButton()
        configureCurrentLocation()
        initRefresh()
    }
    
    private func setUpSerachButton() {
        searchButton.layer.cornerRadius = 7
        searchButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        searchButton.layer.shadowColor = UIColor.darkGray.cgColor
        searchButton.layer.shadowOpacity = 1
    }
    
    private func setUpMainViewModel() {
        mainViewModel.delegate = self
        mainViewModel.setUpDefaultValue()
    }
    
    private func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        cityTableView.refreshControl = refresh
    }
    
    @objc private func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        setUpButton()
        mainViewModel.setUpDefaultValue()
    }
    
    private func setUpButton() {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
        cityNameButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        humidityButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        temperatureButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    @IBAction func tapLabelButton(_ sender: UIButton) {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
        sender.tintColor = .black
        
        if sender.currentImage == UIImage(systemName: "chevron.up") {
            sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            switch sender {
            case cityNameButton:
                mainViewModel.descendingOrderCityNameInKorean()
            case humidityButton:
                mainViewModel.descendingOrderHumidity()
            case temperatureButton:
                mainViewModel.descendingOrderTemperature()
            default: break
            }
        } else {
            sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            switch sender {
            case cityNameButton:
                mainViewModel.ascendingOrderCityNameInKorean()
            case humidityButton:
                mainViewModel.ascendingOrderHumidity()
            case temperatureButton:
                mainViewModel.ascendingOrderTemperature()
            default: break
            }
        }
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        guard mainViewModel.currentWeatherList.first != nil else { return }
        let temperatureUnit = UserDefaults.standard.value(forKey: "temperatureUnit") as? String
        if sender.selectedSegmentIndex == 0 {
            guard temperatureUnit == TemperatureUnit.C.rawValue else { return }
            mainViewModel.convertTemperatureUnitCtoF {
                temperatureLabel.text = "\(mainViewModel.locationTemperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
            }
            
        } else {
            guard temperatureUnit == TemperatureUnit.F.rawValue else { return }
            mainViewModel.convertTemperatureUnitFtoC {
                temperatureLabel.text = "\(mainViewModel.locationTemperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
            }
        }
    }
    
    @IBAction func tapSortButton(_ sender: UIButton) {
        if cityTableView.isEditing {
            cityTableView.isEditing = false
        } else {
            cityTableView.isEditing = true
        }
    }
}

extension MainViewController: CurrentWeatherDataUpdatable {
    func reloadData() {
        DispatchQueue.main.async {
            self.cityTableView.reloadData()
        }
    }
    func updateSegmentControl() {
        DispatchQueue.main.async {
            self.temperatureSegmentControl.selectedSegmentIndex = 0
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.numberOfCurrentWeatherList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCell", for: indexPath) as? CityListCell else { return UITableViewCell() }
        cell.update(data: mainViewModel.currentWeather(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainViewModel.delete(at: indexPath.row)
            cityTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        mainViewModel.currentWeatherList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailInCell", sender: mainViewModel.currentWeatherList[indexPath.row].coordinate)
    }
}
