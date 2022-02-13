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
        let local = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (placemarks, error) in
            guard let placemark: [CLPlacemark] = placemarks,
                  let address = placemark.last?.administrativeArea,
                  let siAddress = placemark.last?.locality else { return }
            if address.contains("특별시") || address.contains("광역시") {
                var resultAddress = String(address).trimmingCharacters(in: ["특", "별", "시", "광", "역"])
                if resultAddress == "주" {
                    resultAddress.insert("광", at: resultAddress.startIndex)
                }
                completion(resultAddress)
            } else {
                var resultSiAddress = String(siAddress).trimmingCharacters(in: ["시"])
                if resultSiAddress == "흥" {
                    resultSiAddress.insert("시", at: resultSiAddress.startIndex)
                }
                completion(resultSiAddress)
            }
        }
    }
}
