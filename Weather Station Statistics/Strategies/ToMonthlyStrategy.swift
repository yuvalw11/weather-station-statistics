//
//  ToMonthlyStrategy.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class ToMonthlyStrategy: CombineStrategyProtocol {
    
    func getGroupDateForDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "M/yyyy"
        return dateFormatter.date(from: dateFormatter.string(from: date))!
    }
    
    func getValues() -> [ValueCollectionProtocol] {
        return [AvgValue(name: "avgTemp", attInRecord: "avgTemp"),
                AvgValue(name: "avgMaxTemp", attInRecord: "maxTemp"),
                AvgValue(name: "avgMinTemp", attInRecord: "minTemperature"),
                AvgValue(name: "avgHum", attInRecord: "avgHum"),
                AvgValue(name: "avgWind", attInRecord: "avgWind"),
                AvgValue(name: "avgABS", attInRecord: "avgABS"),
                AvgValue(name: "avgREL", attInRecord: "avgREL"),
                AvgValue(name: "avgMaxUVI", attInRecord: "maxUVI"),
                AvgValue(name: "avgMaxRad", attInRecord: "maxRad"),
                AccumValue(name: "monthlyRain", attInRecord: "maxDailyRain"),
                MaxValue(name: "maxTemp", attInRecord: "maxTemp"),
                MaxValue(name: "maxHum", attInRecord: "maxHum"),
                MaxValue(name: "maxWind", attInRecord: "maxWind"),
                MaxValue(name: "maxDew", attInRecord: "maxDew"),
                MaxValue(name: "maxRainRate", attInRecord: "maxRainRate"),
                MaxValue(name: "maxDailyRain", attInRecord: "maxDailyRain"),
                MaxValue(name: "maxRad", attInRecord: "maxRad"),
                MaxValue(name: "maxHeatIndex", attInRecord: "maxHeatIndex"),
                MaxValue(name: "maxUVI", attInRecord: "maxUVI"),
                MaxValue(name: "maxREL", attInRecord: "maxREL"),
                MinValue(name: "minTemperature", attInRecord: "minTemperature"),
                MinValue(name: "minHumidity", attInRecord: "minHumidity"),
                MinValue(name: "minDew", attInRecord: "minDew"),
                MinValue(name: "minChill", attInRecord: "minChill"),
                MinValue(name: "minREL", attInRecord: "minREL"),
                AccumValue(name: "rainSpan", attInRecord: "rainSpan"),
                MaxDiffValue(name: "maxDailyTempDiff", attInRecord1: "maxTemp", attInRecord2: "minTemperature"),
                CountValue(name: "numOfRainyDays", attInRecord: "maxDailyRain", predicate: {(x: Double) -> Bool in
                    return x > 0
                }),
                CountValue(name: "numOfHotDays", attInRecord: "maxHeatIndex", predicate: {(x: Double) -> Bool in
                    return x > 25
                })]
    }
}
