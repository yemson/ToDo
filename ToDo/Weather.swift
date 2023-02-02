//
//  Weather.swift
//  ToDo
//
//  Created by 이예민 on 2023/02/02.
//

import Foundation

struct Weather: Decodable {
    var main: String
    var description: String
}

struct WeatherResponse: Decodable {
    let weather: [Weather]
}
