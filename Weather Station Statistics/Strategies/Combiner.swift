//
//  Combiner.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class Combiner {
    private var strategy: CombineStrategyProtocol
    
    init(strategy: CombineStrategyProtocol) {
        self.strategy = strategy
    }
    
    public func combine(records: RecordCollection) -> RecordCollection {
        let groups = self.gatherRecords(records: records)
        var gatheredRecords = Array<Record>()
        for recordGroup in groups {
            let record = self.uniteRecordsToRecord(records: recordGroup, date: self.strategy.getGroupDateForDate(date: recordGroup[0].getDate()))
            
            gatheredRecords.append(record)
        }
        
        return RecordCollection(records: gatheredRecords)
    }
    
    private func uniteRecordsToRecord(records: [Record], date: Date) -> Record {
        var values: Dictionary<String, Double> = [:]
        for valueHandler in self.strategy.getValues() {
            for record in records {
                valueHandler.addRecord(record: record)
            }
            values[valueHandler.getName()] = valueHandler.getValue()
        }
        return Record(values: values, date: date, subRecords: records)
    }
    
    private func gatherRecords(records: RecordCollection) -> [[Record]] {
        var groups = Array<[Record]>()
        var dateToNum: Dictionary<Date, Int> = [:]
        for record in records.getRecords() {
            let recordGroupDate = self.strategy.getGroupDateForDate(date: record.getDate())
            if dateToNum.keys.contains(recordGroupDate) {
                groups[dateToNum[recordGroupDate]!].append(record)
            } else {
                dateToNum[recordGroupDate] = groups.count
                groups.append(Array([record]))
            }
        }
        
        return groups
    }
    
}
