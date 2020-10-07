//
//  ToDailyStrategy.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class ToDailyStrategy: CombineStrategyProtocol {
    
    func getGroupDateForDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "d/M/yyyy"
        return dateFormatter.date(from: dateFormatter.string(from: date))!
    }
    
    
    func getValues() -> [ValueCollectionProtocol] {
        return [AvgValue(name: "avgTemp", attInRecord: "Temperature"),
                AvgValue(name: "avgHum", attInRecord: "Humidity"),
                AvgValue(name: "avgWind", attInRecord: "Wind"),
                AvgValue(name: "avgABS", attInRecord: "ABS"),
                AvgValue(name: "avgREL", attInRecord: "REL"),
                MaxValue(name: "maxTemp", attInRecord: "Temperature"),
                MaxValue(name: "maxHum", attInRecord: "Humidity"),
                MaxValue(name: "maxWind", attInRecord: "Gust"),
                MaxValue(name: "maxDew", attInRecord: "Dew"),
                MaxValue(name: "maxRainRate", attInRecord: "RainRate"),
                MaxValue(name: "maxDailyRain", attInRecord: "DailyRain"),
                MaxValue(name: "maxRad", attInRecord: "Rad"),
                MaxValue(name: "maxHeatIndex", attInRecord: "HeatIndex"),
                MaxValue(name: "maxUVI", attInRecord: "UVI"),
                MaxValue(name: "maxREL", attInRecord: "REL"),
                MinValue(name: "minTemperature", attInRecord: "Temperature"),
                MinValue(name: "minHumidity", attInRecord: "Humidity"),
                MinValue(name: "minDew", attInRecord: "Dew"),
                MinValue(name: "minChill", attInRecord: "Chill"),
                MinValue(name: "minREL", attInRecord: "REL"),
                SpanValue(name: "rainSpan", attInRecord: "RainRate")]
    }
    
    
}
