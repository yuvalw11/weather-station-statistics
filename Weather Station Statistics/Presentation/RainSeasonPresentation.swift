//
//  RainSeasonPresentation.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 02/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class RainSeasonPresentation: StaticPresentationProtocol {
    
    private var seasonRecord: DBRecord
    private var monthsRecords: DBStatement

    init(seasonRecord: DBRecord, monthsRecords: DBStatement) {
        self.seasonRecord = seasonRecord
        self.monthsRecords = monthsRecords
    }
    
    func getTitle() -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let year = Int(dateFormatter.string(from: self.seasonRecord.date))!
        if calendar.component(.month, from: self.seasonRecord.date) == 1 {
            return String(year)
        } else {
            return String(year) + " - " + String(year + 1)
        }
    }
    
    func getLeftText() -> String {
        var str: String = ""
        str += "Rain Accum: " + self.valueToString(val: self.seasonRecord["SeasonalRain"], roundBy: 10) + "\n"
        str += "Number of Rainy days: " + self.valueToString(val: self.seasonRecord["NumberOfRainyDays"], roundBy: 1) + "\n"
        str += "Maximum Rain Rate: " + self.valueToString(val: self.seasonRecord["RainRateMax"], roundBy: 10)
        return str
    }
    
    func getCenterText() -> String {
        return ""
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        return GraphHandler(handlerConfig: RainSeasonGraphHandlerConfiguration(monthsStatement: self.monthsRecords))
    }
    
    private func valueToString(val: Double?, roundBy: Int) -> String {
        if val == nil {
            return "--"
        } else {
            if roundBy != 1 {
                return String(round(val!*Double(roundBy))/Double(roundBy))
            } else {
                return String(Int(val ?? 0))
            }
            
        }
    }
    
}
