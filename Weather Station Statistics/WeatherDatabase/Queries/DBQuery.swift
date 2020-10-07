//
//  DBQuery.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 04/04/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class DBQuery: BaseTable {
    
    var table: TableProtocol
    
    init(db: Connection, table: TableProtocol) {
        self.table = table
        super.init(db: db)
    }
    
    override var query: Table {
        get {
            let date = self.dateColumn;
            var expressions : [Expressible] = [date.alias("Date")]
             
            for (name, exp) in self.expressionsMapper {
                expressions.append(exp.alias(name))
             }
            
            return Table(table: table.query).select(expressions).group([date])
        }
    }
}
