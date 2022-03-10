//
//  GeoManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/06.
//

import Foundation
import CoreLocation

struct AddressManager {
    static func convertCityNameEnglishToKoreanSimply(latitude: Double, longtitude: Double, completion: @escaping (String) -> Void) {
        let findLocation = CLLocation(latitude: latitude, longitude: longtitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { (placemarks, error) in
            guard let placemark: [CLPlacemark] = placemarks,
                  let address = placemark.first?.administrativeArea,
                  let siAddress = placemark.first?.locality else { return }
            let resultAddress = String(address)
            let resultSiAddress = String(siAddress)
            completion("\(resultAddress) \(resultSiAddress)")
        }
    }
}
