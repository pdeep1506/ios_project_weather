//
//  WeatherModal.swift
//  ios_project_2
//
//  Created by SMIT KHOKHARIYA on 2023-08-02.
//

import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
    let location : Location
}

struct Location: Codable {
    let name : String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let temp_f: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let code: Int
}
