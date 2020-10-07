//
//  SpanValue.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 28/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class SpanValue: ValueCollectionProtocol {
    
    private var start: Date?
    private var last: Date?
    private var amountOfSec: Double
    private var name: String
    private var attInRecord: String
    
    init(name: String, attInRecord: String) {
        self.last = nil
        self.amountOfSec = 0
        self.name = name
        self.attInRecord = attInRecord
    }
    
    func addRecord(record: Record) {
        let val = record.getValue(att: self.attInRecord)
        let recDate = record.getDate()
        var interval: Double
        if self.last != nil {
            interval = abs(recDate.timeIntervalSince1970 - (self.last?.timeIntervalSince1970)!)
        } else {
            interval = 0
        }
        if val != nil && val! > 0  && interval < 15 * 60 {
            self.last = recDate
            self.amountOfSec += interval
        } else {
            self.last = nil
        }
    }
    
    func getValue() -> Double? {
        let val = self.amountOfSec
        self.last = nil
        self.amountOfSec = 0
        return val
    }
    
    func getName() -> String {
        return self.name
    }
    
    
}
