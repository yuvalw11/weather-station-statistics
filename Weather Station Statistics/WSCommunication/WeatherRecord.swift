//
//  WeatherRecord.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 06/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

enum WeatherField {
    case inTemp
    case inHumidity
    case outTemp
    case outHumidity
    case wind
    case gust
    case dew
    case windChill
    case windDirection
    case abs
    case rel
    case rainRate
    case dailyRain
    case weeklyRain
    case monthlyRain
    case yearlyRain
    case radiation
    case heatIndex
    case uvi
}

struct WeatherRecord {
    
    var time: Date
    var values: Dictionary<WeatherField, Double?>
    
}
