//
//  DetailTableViewCell.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/12.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    static let identifier = "DailyTableViewCell"
    @IBOutlet weak var dailyTableView: UITableView!
    var dailyWeatherList = [DailyWeather]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dailyTableView.register(DailyListCell.nib(), forCellReuseIdentifier: DailyListCell.identifier)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
    }
    
    static func nib() ->UINib {
        return UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
    }
    
    func update(_ dailyWeatherList: [DailyWeather]) {
        self.dailyWeatherList = dailyWeatherList
        dailyTableView.reloadData()
    }
}

extension DailyTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyListCell.identifier, for: indexPath) as? DailyListCell else { return UITableViewCell() }
        cell.update(data: dailyWeatherList[indexPath.row])
        return cell
    }
}

extension DailyTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
