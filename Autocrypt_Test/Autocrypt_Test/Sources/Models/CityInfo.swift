//
//  City.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/27/24.
//

import Foundation

struct CityInfo: Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinates
}
