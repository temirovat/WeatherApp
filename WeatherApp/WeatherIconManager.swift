//
//  WeatherIconManager.swift
//  WeatherApp
//
//  Created by Alan on 28/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import Foundation
import UIKit

enum WeatherIconManager: String {
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    case UnpredictedIcon = "unpredicted-icon"
    
    init(rawValue: String) {
        switch rawValue {
        case "clear-day": self = .ClearDay
        case "clear-night": self = .ClearNight
        case "rain": self = .Rain
        case "snow": self = .Snow
        case "sleet": self = .Sleet
        case "wind": self = .Wind
        case "fog": self = .Fog
        case "cloudy": self = .Cloudy
        case "partly-cloudy-day": self = .PartlyCloudyDay
        case "partly-cloudy-day": self = .PartlyCloudyNight
        default: self = .UnpredictedIcon
        }
    }
}

extension WeatherIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
