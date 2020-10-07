//
//  MinValue.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class MinValue: ValueCollectionProtocol {
    
    var minValue: Double?
    var name: String
    var attInRecord: String
    
    init(name: String, attInRecord: String) {
        self.minValue = 999999999999
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
        self.minValue = min(self.minValue!, val!)
    }
    
    func getValue() -> Double? {
        let value = self.minValue
        self.minValue = 999999999999
        return value
    }
}

