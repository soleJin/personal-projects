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
            var resultSiAddress = String(siAddress)
            var resultAddress = String(address)
            print(resultAddress)
            resultSiAddress.removeAll { (cityName) -> Bool in
                cityName == "시"
            }
            
//            resultAddress.removeAll { (adress) -> Bool in
//                adress == "특별시"
//            }
            completion(resultSiAddress)
        }
    }
    
    static func convertCityNameEnglishToKoreanInDetail(latitude: Double, longtitude: Double, completion: @escaping (String) -> Void) {
        let findLocation = CLLocation(latitude: latitude, longitude: longtitude)
        let geocoder = CLGeocoder()
        let local = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (placemarks, error) in
            guard let placemark: [CLPlacemark] = placemarks,
                  let siAddress = placemark.last?.locality,
                  let dongAddress = placemark.last?.subLocality,
                  let address = placemark.last?.administrativeArea else { return }
            print("\(String(address)) \(String(siAddress)) \(String(dongAddress))")
            completion("\(String(address)) \(String(siAddress)) \(String(dongAddress))")
        }
    }
}
