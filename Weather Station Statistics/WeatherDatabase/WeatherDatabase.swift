//
//  WeatherDatabase.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 20/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite
import CoreData

class WeatherDatabase {
    
    fileprivate let dbDispatchQueue: DispatchQueue
    
    fileprivate var recordsTable: RecordsTable?
    fileprivate var dayTable: DayTable?
    fileprivate var monthTable: MonthTable?
    fileprivate var yearTable: YearTable?
    fileprivate var rainSeasonTable: RainSeasonTable?

    var dbDays: Dictionary<Date, DBStatement>
    var dbMonths: Dictionary<Date, DBStatement>
    var dbYears: Dictionary<Date, DBStatement>
    var dbRainSeasons: Dictionary<Date, DBStatement>
    var dbRecordsForDay: Dictionary<Date, DBStatement>
    var dbDaysForMonth: Dictionary<Date, DBStatement>
    var dbDaysForYear: Dictionary<Date, DBStatement>
    var dbMonthsForyear: Dictionary<Date, DBStatement>
    var dbMonthsForRainSeason: Dictionary<Date, DBStatement>
    
    fileprivate var observers: [DBObserver]

    init() {
        
        self.dbDispatchQueue = DispatchQueue(label: "dbQueue", qos: .utility)
        
        self.observers = Array()
                
        self.dbDays = Dictionary()
        self.dbMonths = Dictionary()
        self.dbYears = Dictionary()
        self.dbRainSeasons = Dictionary()
        self.dbRecordsForDay = Dictionary()
        self.dbDaysForMonth = Dictionary()
        self.dbDaysForYear = Dictionary()
        self.dbMonthsForyear = Dictionary()
        self.dbMonthsForRainSeason = Dictionary()

        self.dbDispatchQueue.async {
            let db = try! Connection(ApplicationSetup.pathToDB)
            self.recordsTable = RecordsTable(db: db, name: "Records")
            self.dayTable = DayTable(db: db, table: self.recordsTable!)
            self.monthTable = MonthTable(db: db, table: self.dayTable!)
            self.yearTable = YearTable(db: db, table: self.monthTable!)
            self.rainSeasonTable = RainSeasonTable(db: db, table: self.monthTable!)
            
            try! self.recordsTable?.create()
        }
    }
    
    func set() {
        self.dbDispatchQueue.async {
            self.updateContainers()
        }
    }
    
    func set(wsConnector: WsConnector, queryForUpdatesEvery: UInt32 = 0) {
        if wsConnector.isConnected {
            WSSyncronizer(wsConnector: wsConnector, db: self).monitorWS(monitorEvery: queryForUpdatesEvery)
        }
    }
    
    func recordsForYear() throws -> Dictionary<Int, Int> {
        return try self.recordsTable!.getYearsData()
    }
    
    fileprivate func insert(records: [Record], shouldUpdateContainers: Bool) {
        self.recordsTable!.insertRecords(records: records)
        if shouldUpdateContainers{
            self.updateContainers()
        }
    }
        
    func insertRecords(records: [Record]) {
        self.insert(records: records, shouldUpdateContainers: true)
        self.observers.forEach { (observer) in
            observer.recordInserted(total: records.count)
        }
    }
    
    func createInsertSession(id: String) -> InsertSession {
        return InsertSession(id: id, db: self)
    }
                
    fileprivate func updateContainers() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let lowDate = self.dbDays.keys.sorted().last ?? self.getLowestDate()!
        let highDate = self.recordsTable!.highestDate
        
        var min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .month, .year), from: lowDate))!
        var max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .month, .year), from: highDate))!
        var newContainer = self.monthTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), month: 1))
        self.dbMonths.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: lowDate))!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: highDate))!
        newContainer = self.yearTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), year: 1))
        self.dbYears.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .month, .year), from: lowDate))!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .month, .year), from: highDate))!
        newContainer = self.dayTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), month: 1))
        self.dbDaysForMonth.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: lowDate))!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: highDate))!
        newContainer = self.dayTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), year: 1))
        self.dbDaysForYear.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: lowDate))!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: highDate))!
        newContainer = self.monthTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), year: 1))
        self.dbMonthsForyear.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .day, .month, .year), from: lowDate))!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .day, .month, .year), from: highDate))!
        newContainer = self.dayTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), day: 1))
        self.dbDays.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .day, .month, .year), from: lowDate))!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .day, .month, .year), from: highDate))!
        newContainer = self.recordsTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), day: 1))
        self.dbRecordsForDay.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: lowDate))!
        min = calendar.date(byAdding: DateComponents(month: ApplicationSetup.rainSeasonStartMonth - 1), to: min)!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: highDate))!
        max = calendar.date(byAdding: DateComponents(month: ApplicationSetup.rainSeasonStartMonth - 1), to: max)!
        newContainer = self.rainSeasonTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), year: 1)) { date in
            return calendar.date(byAdding: DateComponents(month: -(ApplicationSetup.rainSeasonStartMonth - 1)), to: date)!
        }
        self.dbRainSeasons.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        min = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: lowDate))!
        min = calendar.date(byAdding: DateComponents(month: ApplicationSetup.rainSeasonStartMonth - 1), to: min)!
        max = calendar.date(from: calendar.dateComponents(Set(arrayLiteral: .year), from: highDate))!
        max = calendar.date(byAdding: DateComponents(month: ApplicationSetup.rainSeasonStartMonth - 1), to: max)!
        newContainer = self.monthTable!.getContainerFromDate(from: min, to: max, componentsToAdd: DateComponents(timeZone: TimeZone(abbreviation: "GMT"), year: 1)) { date in
            return calendar.date(byAdding: DateComponents(month: -(ApplicationSetup.rainSeasonStartMonth - 1)), to: date)!
        }
        self.dbMonthsForRainSeason.merge(newContainer) {(oldStatement, newStatement) in return newStatement}
        
        
        self.observers.forEach {$0.recordsChanged()}
    }
    
    func getHighestDate() -> Date? {
        guard let recordsTable = self.recordsTable else {
            return nil
        }
        return recordsTable.highestDate
    }
    
    func getLowestDate() -> Date? {
        guard let recordsTable = self.recordsTable else {
            return nil
        }
        return recordsTable.lowestDate
    }
   
    func assignObserver(observer: DBObserver) {
        self.observers.append(observer)
    }
    
}

class InsertSession {
    
    private let db: WeatherDatabase
    let id: String
    private var _totalRecords: Int
    private var _currentlyInserted: Int
    
    init(id: String, db: WeatherDatabase) {
        self.id = id
        self.db = db
        self._totalRecords = 0
        self._currentlyInserted = 0
    }
    
    func start(total: Int) {
        self._totalRecords = total
        self._currentlyInserted = 0
        self.updateObservers()
    }
    
    func insert(records: [Record]) {
        let shouldUpdateContainers = (self._totalRecords <= self.currentlyInserted + records.count)
        self.db.insert(records: records, shouldUpdateContainers: shouldUpdateContainers)
        self._currentlyInserted += records.count
        self.updateObservers()
    }
    
    var currentlyInserted: Int {
        return self._currentlyInserted
    }
    
    var totalRecords: Int {
        return self._totalRecords
    }
    
    var ended: Bool {
        return self._currentlyInserted >= self._totalRecords
    }
    
    private func updateObservers() {
        db.observers.forEach { (observer) in
            observer.recordInserted(session: self)
        }
    }
}
