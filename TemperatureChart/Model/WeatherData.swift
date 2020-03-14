//
//  WeatherData.swift
//  TemperatureChart
//
//  Created by Triet Le on 14.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let data: DataClass
    let errors: [DataError]?
}

struct DataClass: Codable {
    let me: Me?
}

struct Me: Codable {
    let home: Home
}

struct Home: Codable {
    let weather: Weather
}

struct Weather: Codable {
    let minTemperature, maxTemperature: Double
    let entries: [Entry]
}

struct Entry: Codable {
    let time: Date
    let temperature: Double?
    let type: String?
}

struct DataError: Codable {
    let message: String
}


