//
//  DBTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 04/04/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class DBTable: BaseTable {
    
    private let name: String
    
    init(db: Connection, name: String) {
        self.name = name
        super.init(db: db)
    }
    
    func create() throws {
        try self.db.run(self.query.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {
            (builder) in
            builder.column(Expression<Int64>("Id"), primaryKey: .autoincrement)
            builder.column(self.dateColumn)
            for (_, exp) in self.expressionsMapper {
                builder.column(exp, unique: false)
            }
        }))
    }
    
    func insertRecords(records: [Record]) {
        for record in records {
            self.insertRecord(record: record)
        }
    }
    
    private func insertRecord(record: Record) {
        var setters = Array<Setter>()
        let dateExp = self.dateColumn
        
        let recordDate = record.getDate()
        
        setters.append(dateExp <- recordDate)
        
        for name in self.fieldNames {
            let exp = Expression<Double?>(name)
            let val = record.getValue(att: name)
            if val != nil {
                setters.append(exp <- val!)
            }
        }
        
        do {
            try self.db.run(self.query.insert(setters))
        } catch let error {
            print("record could not have been inserted: \(error)")
            print("of date \(recordDate)")
        }
    }

    override var query: Table {
        return Table(self.name)
    }
    
    override var expressionsMapper: Dictionary<String, Expression<Double?>> {
        var mapper = Dictionary<String, Expression<Double?>>()
        for name in self.fieldNames {
            mapper[name] = Expression<Double?>(name)
        }
        return mapper
    }
    
    var fieldNames: Array<String> {
        return []
    }
}

