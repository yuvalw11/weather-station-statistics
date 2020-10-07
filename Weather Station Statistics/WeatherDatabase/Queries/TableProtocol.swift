//
//  TableProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 21/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

protocol TableProtocol {
    var query: Table {get}
    
    var dateColumn: Expression<Date> {get}
    
    var highestDate: Date { get }
    var lowestDate: Date { get }
    
    func getRowForDate(date: Date) -> DBRecord?
    func getRowsForRange(from: Date, range: DateComponents, lazy: Bool) -> DBStatement?
    func getRowForIndex(index: Int) -> DBRecord?
}
