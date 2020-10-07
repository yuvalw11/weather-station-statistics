//
//  ProcessedData.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 14/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class ProcessedData {
    
    private var records: RecordCollection
    private var days: RecordCollection
    private var months: RecordCollection
    private var years: RecordCollection
    private var seasonal: RecordCollection
    private var lowestDate: Date
    private var highestDate: Date
    private var fileToRecords: FileToRecordsProtocol
    
    init(fileToRecords: FileToRecordsProtocol) {
        self.records = RecordCollection(records: [])
        self.days = RecordCollection(records: [])
        self.months = RecordCollection(records: [])
        self.years = RecordCollection(records: [])
        self.seasonal = RecordCollection(records: [])
        self.lowestDate = Date(timeIntervalSince1970: TimeInterval(exactly: 0)!)
        self.highestDate = Date(timeIntervalSinceNow: TimeInterval(exactly: 0)!)
        self.fileToRecords = fileToRecords
    }
    
    func setNewFiles(csvUrls: [URL]) {
        let toDailyCombiner = Combiner(strategy: ToDailyStrategy())
        let toMonthlyCombiner = Combiner(strategy: ToMonthlyStrategy())
        let toYearlyCombiner = Combiner(strategy: ToYearlyStrategy())
        let toSeasonalCombiner = Combiner(strategy: ToRainSeasonStrategy(monthToStart: 8))
        
        var rawRecords = Array<Record>()
        
        for url in csvUrls {
            rawRecords.append(contentsOf: fileToRecords.fileToRecord(file: url))
        }
        
        self.records = RecordCollection(records: rawRecords)
        
        var low = self.records.getRecords().randomElement()!.getDate()
        var high = self.records.getRecords().randomElement()!.getDate()
        
        for record in rawRecords {
            let date = record.getDate()
            if record.getDate() < low {
                low = date
            }
            if record.getDate() > high {
                high = date
            }
        }
        self.highestDate = high
        self.lowestDate = low
        
        self.days = toDailyCombiner.combine(records: self.records)
        self.months = toMonthlyCombiner.combine(records: self.days)
        self.years = toYearlyCombiner.combine(records: self.months)
        self.seasonal = toSeasonalCombiner.combine(records: self.months)
    }
    
    func getHighestDate() -> Date {
        return self.highestDate
    }
    
    func getLowestDate() -> Date {
        return self.lowestDate
    }
    
//    func getPresentation(mode: TimeMode, date: Date) -> PresentationProtocol {
//        if mode == .Day {
//            if self.days.hasDate(date: date) {
//                return DayPresentation(record: self.days.getRecordByDate(date: date)!)
//            } else {
//                return EmptyPresentaion()
//            }
//        } else if mode == .Month {
//            if self.months.hasDate(date: date) {
//                return MonthPresentation(record: self.months.getRecordByDate(date: date)!)
//            } else {
//                return EmptyPresentaion()
//            }
//        } else if mode == .Year{
//            if self.years.hasDate(date: date) {
//                return YearPresentation(record: self.years.getRecordByDate(date: date)!)
//            } else {
//                return EmptyPresentaion()
//            }
//        } else {
//            if self.seasonal.hasDate(date: date) {
//                return RainSeasonPresentation(record: self.seasonal.getRecordByDate(date: date)!)
//            } else {
//                return EmptyPresentaion()
//            }
//            
//        }
//    }
    
    
    
}


