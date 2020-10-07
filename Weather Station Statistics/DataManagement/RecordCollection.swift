//
//  RecordCollection.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 08/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class RecordCollection {
    private var records: [Record]
    private var dateToRecordMapper: Dictionary<Date, Int>
    
    public init(records: [Record]) {
        self.records = records
        self.dateToRecordMapper = [:]
        var i = 0
        for record in records {
            self.dateToRecordMapper[record.getDate()] = i
            i+=1
        }
        
    }
    
    public func getRecordsForRange(from: Date, to: Date) -> [Record] {
        
        let start = from < self.minDate ? 0 : self.dateToRecordMapper[from]!
        let end = to > self.maxDate ? (self.records.count - 1) : self.dateToRecordMapper[to]!
        
        return Array(self.records[start..<end])
    }
    
    public func getRecordByDate(date: Date) -> Record? {
        return self.records[self.dateToRecordMapper[date]!]
    }
    
    public func getRecords() -> [Record] {
        return self.records
    }
    
    public func getSize() -> Int {
        return self.records.count
    }
    
    public func hasDate(date: Date) -> Bool {
        return self.dateToRecordMapper.keys.contains(date)
    }
    
    private var maxDate: Date {
        return self.records.last!.getDate()
    }
    
    private var minDate: Date {
        return self.records[0].getDate()
    }
}
