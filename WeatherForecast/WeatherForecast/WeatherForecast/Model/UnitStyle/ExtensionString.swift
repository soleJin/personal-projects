//
//  ExtensionString.swift
//  WeatherForecast
//
//  Created by sole on 2022/03/16.
//

import UIKit

extension String {
    func convertToNSMutableAttributedString(ranges: [NSValue], fontSize: CGFloat, fontWeight: UIFont.Weight, fontColor: CGColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: fontColor
        ]
        let attributedString = NSMutableAttributedString(string: self)
        if let range = ranges.first as? NSRange {
            attributedString.addAttributes(attributes, range: range)
        }
        return attributedString
    }
}
