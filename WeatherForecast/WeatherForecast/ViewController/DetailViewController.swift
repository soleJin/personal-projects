//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/09.
//

import UIKit

class DetailViewController: UIViewController {
    var coord: Coordinate? = nil
    let daiyWeather: DailyWeather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(coord)
    }
}


