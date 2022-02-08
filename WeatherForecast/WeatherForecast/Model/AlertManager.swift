//
//  AlertManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/08.
//

import UIKit

struct AlertManager {
    static func promptForAuthorization() -> UIAlertController {
        let alert = UIAlertController(title: "현재 위치의 날씨정보를\n조회하기 위해\n위치접근 허용이 필요합니다.", message: "위치접근을 허용해주세요!", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel , handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        alert.preferredAction = settingsAction
        return alert
    }
    
    static func promptForWrongCityName() -> UIAlertController {
        let alert = UIAlertController(title: "도시 이름을 확인해주세요.", message: nil, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(settingsAction)
        alert.preferredAction = settingsAction
        return alert
    }
}
