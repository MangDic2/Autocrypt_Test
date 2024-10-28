//
//  WeatherBackground.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/27/24.
//

import UIKit

enum WeatherBackground: String {
    case clouds
    case sunny
    case fog
    case rain
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}

extension WeatherCondition {
    var background: WeatherBackground {
        switch self {
        case .clearSky, .fewClouds:
            return .sunny
        case .scatteredClouds, .brokenClouds, .overcastClouds:
            return .clouds
        case .lightRain, .moderateRainWithSun, .thunderstorm:
            return .rain
        case .snow, .lightSnow, .mist:
            return .fog
        }
    }
}
