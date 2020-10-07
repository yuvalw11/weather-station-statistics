//
//  DataType.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

extension ParameterType: CaseIterable {}

enum ParameterType: String {
    case Time = "Time"
    case Temperature = "Temperature"
    case Humidity = "Humidity"
    case Wind = "Wind"
    case Gust = "Gust"
    case Dew = "Dew"
    case Chill = "Chill"
    case Direction = "Direction"
    case ABS = "ABS"
    case REL = "REL"
    case RainRate = "RainRate"
    case DailyRain = "DailyRain"
    case MonthlyRain = "MonthlyRain"
    case YearlyRain = "YearlyRain"
    case Rad = "Rad"
    case HeatIndex = "HeatIndex"
    case UV = "UV"
    case UVI = "UVI"
}

enum TimeMode: String {
    case Home = "Home"
    case Day = "Daily"
    case Month = "Monthly"
    case Year = "Yearly"
    case Season = "Rain Season"
}

