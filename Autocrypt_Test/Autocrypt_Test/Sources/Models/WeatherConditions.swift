//
//  WeatherConditions.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/27/24.
//

import UIKit

enum WeatherCondition: String {
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case overcastClouds = "overcast clouds"
    case lightRain = "light rain"
    case lightSnow = "light snow"
    case moderateRainWithSun = "moderate rain"
    case thunderstorm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
    
    var description: String {
        switch self {
        case .clearSky:
            return "맑음"
        case .fewClouds:
            return "구름 약간"
        case .scatteredClouds:
            return "구름 많음"
        case .brokenClouds, .overcastClouds:
            return "흐림"
        case .lightRain:
            return "약한 비"
        case .moderateRainWithSun:
            return "비와 햇살"
        case .thunderstorm:
            return "천둥번개"
        case .snow:
            return "눈"
        case .lightSnow:
            return "약한 눈"
        case .mist:
            return "안개"
        }
    }
    
    var iconName: String {
        switch self {
        case .clearSky:
            return "01d"
        case .fewClouds:
            return "02d"
        case .scatteredClouds:
            return "03d"
        case .brokenClouds, .overcastClouds:
            return "04d"
        case .lightRain:
            return "09d"
        case .moderateRainWithSun:
            return "10d"
        case .thunderstorm:
            return "11d"
        case .snow, .lightSnow:
            return "13d"
        case .mist:
            return "50d"
        }
    }
    
    var icon: UIImage? {
        return UIImage(named: iconName)
    }
}
