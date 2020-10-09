//
//  BaseTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 21/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class BaseTable {
   
    var db: Connection
    static var calendar = Calendar.current
    
    init(db: Connection) {
        self.db = db
        BaseTable.calendar.timeZone = TimeZone(abbreviation: "GMT")!
    }
    
    func getRowsForRange(from: Date, range: DateComponents, lazy: Bool = false) -> DBStatement? {
        let dateExp = self.dateColumn
        let predicate = (dateExp >= from) && (dateExp < Calendar.current.date(byAdding: range, to: from)!)
        return DBStatement(query: self.query.where(predicate).asSQL(), db: self.db, lazy: lazy)
    }
    
    func getYearsData() throws -> Dictionary<Int, Int> {
        
        var yearsData = Dictionary<Int, Int>()
        let yearExp = self.dateColumn.year
        let countExp = Expression<Int64>("Id").count
        let query = self.query.select(countExp, yearExp).group(yearExp)
        for row in try self.db.prepare(query) {
            yearsData[Int(row[yearExp])] = row[countExp]
            print("detected \(row[countExp]) rows in \(row[yearExp]) file")
        }
        return yearsData
    }
    
    
    var highestDate: Date {
        do {
            let date = self.dateColumn
            let query = Table(table: self.query).select(date.max)
            let row = try self.db.pluck(query)
            return row![date.max]!
        } catch {
            print("could not get max date")
        }
        return Date()
    }
    
    var lowestDate: Date {
        do {
            let date = self.dateColumn
            let query = Table(table: self.query).select(date.min)
            let row = try self.db.pluck(query)
            return row![date.min]!
        } catch {
            print("could not get max date")
        }
        return Date()
    }
    
    public func getContainerFromDate(from: Date, to: Date, componentsToAdd: DateComponents, lazy: Bool = false, saveDateAs: (Date) -> Date = {date in return date}) -> Dictionary<Date, DBStatement> {
        var date = from
        var container = Dictionary<Date, DBStatement>()
        
        while date <= to {
            let until: Date = BaseTable.calendar.date(byAdding: componentsToAdd, to: date)!
            container[saveDateAs(date)] = self.getRowsForRange(from: date, range: componentsToAdd, lazy: lazy)!
            date = until
        }
        return container
    }
    
    func getRowForDate(date: Date) -> DBRecord? {
        let predicate = (self.dateColumn == date)
        let statement = DBStatement(query: self.query.filter(predicate).asSQL(), db: self.db)
        return statement.first
    }
    
    func getRowForIndex(index: Int) -> DBRecord? {
        let statement = DBStatement(query: self.query.limit(1, offset: index).asSQL(), db: self.db)
        return statement.first
    }
    
    func getRowsByValue<T: Value>(field: String, value: T) -> DBStatement where T.Datatype : Equatable {
        let predicate = (Expression<T>(field) == value)
        return DBStatement(query: self.query.filter(predicate).asSQL(), db: self.db)
    }
    
    var rows: DBStatement {
        return DBStatement(query: self.query.asSQL(), db: self.db)
    }
    
    var count: Int {
        do {
            let row = try self.db.pluck(self.query.select(*).count)!
            return row[Expression<Int>(literal: "*").count]
        } catch {
            return 0
        }
        
    }
    
    var dateColumn: Expression<Date> {
        return Expression<Date>("Date")
    }
    
    var query: Table {
        return Table("")
    }
    
    var expressionsMapper: Dictionary<String, Expression<Double?>> {
        return Dictionary<String, Expression<Double?>>()
    }
       
    var recordsIterator: DBStatement? {
        return DBStatement(query: self.query.asSQL(), db: self.db)
    }
}
