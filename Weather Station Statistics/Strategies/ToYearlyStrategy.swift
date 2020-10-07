//
//  ToYearlyStrategy.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class ToYearlyStrategy: CombineStrategyProtocol {
    
    func getGroupDateForDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.date(from: dateFormatter.string(from: date))!
    }
    
    func getValues() -> [ValueCollectionProtocol] {
        return [AvgValue(name: "avgTemp", attInRecord: "avgTemp"),
                AvgValue(name: "avgHum", attInRecord: "avgHum"),
                AvgValue(name: "avgWind", attInRecord: "avgWind"),
                AvgValue(name: "avgABS", attInRecord: "avgABS"),
                AvgValue(name: "avgREL", attInRecord: "avgREL"),
                AvgValue(name: "avgMaxTemp", attInRecord: "avgMaxTemp"),
                AvgValue(name: "avgMinTemp", attInRecord: "avgMinTemp"),
                MaxValue(name: "maxTemp", attInRecord: "maxTemp"),
                MaxValue(name: "maxHum", attInRecord: "maxHum"),
                MaxValue(name: "maxWind", attInRecord: "maxWind"),
                MaxValue(name: "maxDew", attInRecord: "maxDew"),
                MaxValue(name: "maxRainRate", attInRecord: "maxRainRate"),
                MaxValue(name: "maxDailyRain", attInRecord: "maxDailyRain"),
                MaxValue(name: "maxMonthlyRain", attInRecord: "monthlyRain"),
                AccumValue(name: "yearlyRain", attInRecord: "monthlyRain"),
                MaxValue(name: "maxREL", attInRecord: "maxREL"),
                AccumValue(name: "monthlyRain", attInRecord: "monthlyRain"),
                AccumValue(name: "numOfRainyDays", attInRecord: "numOfRainyDays"),
                AccumValue(name: "numOfHotDays", attInRecord: "numOfHotDays"),
                AccumValue(name: "rainSpan", attInRecord: "rainSpan"),
                MaxValue(name: "maxRad", attInRecord: "maxRad"),
                MaxValue(name: "maxHeatIndex", attInRecord: "maxHeatIndex"),
                MaxValue(name: "maxUVI", attInRecord: "maxUVI"),
                MinValue(name: "minTemperature", attInRecord: "minTemperature"),
                MinValue(name: "minHumidity", attInRecord: "minHumidity"),
                MinValue(name: "minDew", attInRecord: "minDew"),
                MinValue(name: "minChill", attInRecord: "minChill"),
                MinValue(name: "minREL", attInRecord: "minREL"),
                MaxValue(name: "maxDailyTempDiff", attInRecord: "maxDailyTempDiff")]
    }
}
