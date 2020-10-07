//
//  AvgValue.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class AvgValue: ValueCollectionProtocol {
    
    var sum: Double
    var num: Int
    var name: String
    var attInRecord: String
    
    init(name: String, attInRecord: String) {
        self.sum = 0.0
        self.num = 0
        self.name = name
        self.attInRecord = attInRecord
    }
    
    func getName() -> String {
        return self.name
    }
    
    func addRecord(record: Record) {
        let val = record.getValue(att: self.attInRecord)
        if val == nil {
            return
        }
        self.sum += val!
        self.num += 1
    }
    
    func getValue() -> Double? {
        let value = self.sum / Double(self.num)
        self.sum = 0.0
        self.num = 0
        return value
    }
    
    
}
