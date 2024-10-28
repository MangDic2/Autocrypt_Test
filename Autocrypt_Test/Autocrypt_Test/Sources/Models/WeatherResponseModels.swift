//
//  WeatherResponseModels.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import Foundation

struct CityWeather: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherEntry]
    let city: City
}

// 개별 날씨
struct WeatherEntry: Codable {
    let dt: Int
    let main: WeatherMain
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// 온도, 기압, 습도
struct WeatherMain: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// 날씨 상태
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// 구름
struct Clouds: Codable {
    let all: Int
}

// 바람
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// 강수량
struct Rain: Codable {
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}

// 주간, 야간
struct Sys: Codable {
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

// 도시 좌표
struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}
