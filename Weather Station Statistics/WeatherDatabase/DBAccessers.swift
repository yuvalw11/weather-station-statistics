//
//  DBAccessors.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/04/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class DBStatement: Sequence {
    
    var fieldMapper: Dictionary<String, Int?>
    
    private let db: Connection
    private var query: String
    private let bindings: [Binding]
    
    fileprivate var records: [DBRecord]
    private var processed: Bool
    
    let recordsSemaphore = DispatchSemaphore(value: 1)
    static var queue: DispatchQueue = DispatchQueue(label: "DBStatementsQueue", qos: .background)
    
    public init(query: String, db: Connection, lazy: Bool = false) {
        self.db = db
        self.query = query
        self.bindings = []
        
        self.fieldMapper = Dictionary<String, Int?>()
        
        self.records = []
        self.processed = false
        if !lazy {
            self.asyncProcess()
        }
    }
        
    private func asyncProcess() {
        DBStatement.queue.async {
            if !self.processed {
                self.process()
            }
        }
    }
    
    private func syncProcess() {
        if !self.processed {
            DBStatement.queue.suspend()
            self.process()
            DBStatement.queue.resume()
        }
    }
    
    private func process() {
        if !self.processed {
            let statement = try! self.db.prepare(self.query, [])
            
            for i in 0..<statement.columnCount {
                self.fieldMapper[statement.columnNames[i]] = i
            }
            for element in statement {
                self.records.append(DBRecord(element: element, fieldMapper: self.fieldMapper))
            }
            self.processed = true
        }
    }
    
    public var first: DBRecord? {
        self.syncProcess()
        if self.records.count >= 1 {
            return self.records[0]
        } else {
            return nil
        }
    }
    
    func makeIterator() -> DBStatementIterator {
        if !self.processed {
            self.syncProcess()
        }
        return DBStatementIterator(self)
    }
    
    public var Records: [DBRecord] {
        if !self.processed {
            self.syncProcess()
        }
        return self.records
    }
    
    public var IsProcessed: Bool {
        return self.processed
    }
}

class DBRecord {
    
    let formatter = DateFormatter()
    
    let element: Statement.Element
    let fieldMapper: Dictionary<String, Int?>
    
    public init(element: Statement.Element, fieldMapper: Dictionary<String, Int?>) {
        self.element = element
        self.fieldMapper = fieldMapper
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
    }
    
    public subscript(field: String) -> Double? {
        return self.element[self.fieldMapper[field]!!] as? Double
    }
    
    public var date: Date {
        let dateStr = self.element[self.fieldMapper["Date"]!!] as! String
        return self.formatter.date(from: dateStr)!
    }
}

class DBStatementIterator: IteratorProtocol {
    
    private var dbStatement: DBStatement
    private var count: Int
    
    fileprivate init(_ dbStatement: DBStatement) {
        self.dbStatement = dbStatement
        self.count = 0
    }
    
    func next() -> DBRecord? {
        if self.count == self.dbStatement.records.count {
            self.count = 0
            return nil
        } else {
            return self.dbStatement.records[self.count]
        }
        
    }
}
