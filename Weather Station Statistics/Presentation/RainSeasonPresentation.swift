//
//  RainSeasonPresentation.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 02/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class RainSeasonPresentation: StaticPresentationProtocol {
    
    private var record: Record
    private var subRecords: RecordCollection
    
    init(record: Record) {
        self.record = record
        self.subRecords = RecordCollection(records: record.getSubRecords())
    }
    
    init(record: Record, subRecords: RecordCollection) {
        self.record = record
        self.subRecords = subRecords
    }
    
    
    func getTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let year = Int(dateFormatter.string(from: self.record.getDate()))!
        return String(year) + " - " + String(year + 1)
    }
    
    func getLeftText() -> String {
        var str: String = ""
        str += "Rain Accum: " + self.valueToString(val: self.record.getValue(att: "seasonalRain"), roundBy: 10) + "\n"
        str += "Number of Rainy days: " + self.valueToString(val: self.record.getValue(att: "numOfRainyDays"), roundBy: 1) + "\n"
        str += "Rain Time: " + self.valueToString(val: (self.record.getValue(att: "rainSpan") ?? 0) / 3600, roundBy: 10) + " hours"
        return str
    }
    
    func getCenterText() -> String {
        return ""
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        let startDate = self.record.getDate()
        let components = DateComponents(calendar: Calendar.current, year: 1)
        let endDate = Calendar.current.date(byAdding: components, to: startDate)!
//        return RainSeasonGraphHandler(records: self.subRecords.getRecordsForRange(from: startDate, to: endDate), title: self.getTitle() + " Rain Season")
        return nil
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
