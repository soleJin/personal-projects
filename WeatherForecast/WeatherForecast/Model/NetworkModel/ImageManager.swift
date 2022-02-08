//
//  ImageManager.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/04.
//

import UIKit

class ImageManager {
    static let cachedIcons = NSCache<NSString, UIImage>()
    
    static func getImage(_ path: String) -> UIImage {
        let cachedKey = NSString(string: path)
        guard let wantedIcon = cachedIcons.object(forKey: cachedKey) else {
            let iconUrlString = "\(APIType.weatherIcon)\(path).png"
            guard let iconUrl = URL(string: iconUrlString),
                  let iconData = try? Data(contentsOf: iconUrl) else { return UIImage() }
            guard let icon = UIImage(data: iconData) else { return UIImage() }
            cachedIcons.setObject(icon, forKey: cachedKey)
            return icon
        }
        return  wantedIcon
    }
}
