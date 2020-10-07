//
//  DiffValue.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 28/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class MaxDiffValue: ValueCollectionProtocol {
    
    private var name: String
    private var attInRecord1: String
    private var attInRecord2: String
    private var diff: Double
    
    init(name: String, attInRecord1: String, attInRecord2: String) {
        self.name = name
        self.attInRecord1 = attInRecord1
        self.attInRecord2 = attInRecord2
        self.diff = 0
    }
    
    func addRecord(record: Record) {
        let val1 = record.getValue(att: self.attInRecord1)
        let val2 = record.getValue(att: self.attInRecord2)
        if val1 == nil || val2 == nil{
            return
        }
        let val = abs(val1! - val2!)
        self.diff = max(self.diff, val)
    }
    
    func getValue() -> Double? {
        let value = self.diff
        self.diff = 0
        if value == 0 {
            return nil
        }
        return value
    }
    
    func getName() -> String {
        return self.name
    }
    
    
}
