//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetailInButton" || segue.identifier == "showDetailInCell",
              let location = sender as? Coordinate else { return }
        let detailViewController = segue.destination as? DetailViewController
        detailViewController?.coord = location
        dump(detailViewController?.coord)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureSegmentControl.selectedSegmentIndex = 1
        setUpMainViewModel()
        setUpSearchBar()
        setUpButton()
        configureCurrentLocation()
        initRefresh()
    }
    
    private func setUpMainViewModel() {
        mainViewModel.delegate = self
        mainViewModel.loadEachCurrentWeather()
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
        mainViewModel.loadEachCurrentWeather()
    }
    
    private func setUpButton() {
        cityNameButton.tintColor = .darkGray
        humidityButton.tintColor = .darkGray
        temperatureButton.tintColor = .darkGray
        cityNameButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        humidityButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        temperatureButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    private func setUpSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.tintColor = .darkGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "도시 이름을 검색하세요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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
        guard let weather = mainViewModel.currentWeatherList.first else { return }
        if sender.selectedSegmentIndex == 0 {
            if weather.temperatureUnit == .C {
                mainViewModel.convertTemperatureUnitCtoF {
                    temperatureLabel.text = "\(mainViewModel.locationTemperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
                }
            }
        } else {
            if weather.temperatureUnit == .F {
                mainViewModel.convertTemperatureUnitFtoC {
                    temperatureLabel.text = "\(mainViewModel.locationTemperature.toOneDecimalPlaceInString()) \(WeatherSymbols.temperature)"
                }
            }
        }
    }
    
    @IBAction func tapLocationWeatherButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showDetailInButton", sender: mainViewModel.locationCoordinate)
    }
    
    @IBAction func tapSortButton(_ sender: UIButton) {
        if cityTableView.isEditing {
            cityTableView.isEditing = false
        } else {
            cityTableView.isEditing = true
        }
    }
}

extension MainViewController: DataUpdatable {
    func reloadData() {
        DispatchQueue.main.async {
            self.cityTableView.reloadData()
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
