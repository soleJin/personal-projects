//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import Foundation
import CoreLocation

class LocationService {
    let manager = CLLocationManager()
    manager

    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        status == .authorizedAlways || status == .authorizedWhenInUse {
//
//        }
//    }
//
}

extension LocationService: CLLocationManagerDelegate {
    private func setUpLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        checkLocationPermission()
    }
    
    func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }
    
    func getAddress(from: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(from) { (placemarks, error) in
            if let error = error {
                return
            }
            else if let placemarks = placemarks {
                for placemakr in placemarks {
                    let address = [placemakr.name,
                    placemakr.subThoroughfare,
                    placemakr.thoroughfare,
                    placemakr.locality,
                    placemakr.subAdministrativeArea,
                    placemakr.administrativeArea,
                    placemakr.country,
                    placemakr.postalCode].compactMap { $0 }.joined(separator: ", ")
                    print(address)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    
}
