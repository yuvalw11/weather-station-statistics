//
//  ToRainSeasonStrategy.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 02/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class ToRainSeasonStrategy: CombineStrategyProtocol {
    
    private var monthToStart: Int
    
    init(monthToStart: Int) {
        self.monthToStart = monthToStart
    }
    
    func getGroupDateForDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "M"
        let mounth = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "yyyy"
        var year = Int(dateFormatter.string(from: date))!
        if self.monthToStart > mounth {
            year -= 1
        }
        return dateFormatter.date(from: String(year))!
    }
    
    func getValues() -> [ValueCollectionProtocol] {
        return [AccumValue(name: "seasonalRain", attInRecord: "monthlyRain"),
                AccumValue(name: "numOfRainyDays", attInRecord: "numOfRainyDays"),
                AccumValue(name: "rainSpan", attInRecord: "rainSpan")]
    }
    
}
