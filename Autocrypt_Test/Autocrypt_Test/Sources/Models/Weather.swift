//
//  Weather.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import Foundation

// 현재 날씨 정보
struct CurrentWeatherInfo {
    let temperature: Double
    let cityName: String
    let weatherDescription: String
    let maxTemp: Double
    let minTemp: Double
}

// 시간별 날씨 데이터 (3시간 간격)
struct HourlyWeatherInfo {
    let time: String
    let temperature: Double
    let weatherDescription: String
}

// 일별 날씨 데이터
struct DailyWeatherInfo {
    let date: String
    let maxTemp: Double
    let minTemp: Double
    let weatherDescription: String
}

// 좌표 데이터
struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

// 추가 날씨 정보
struct AdditionalWeatherInfo {
    let humidity: Int
    let cloudiness: Int
    let windSpeed: Double
    let gustSpeed: Double?
    let pressure: Int
}

