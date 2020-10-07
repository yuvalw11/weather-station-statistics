//
//  MaxValue.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class MaxValue: ValueCollectionProtocol {
    
    var maxValue: Double?
    var name: String
    var attInRecord: String
    
    init(name: String, attInRecord: String) {
        self.maxValue = -999999999999
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
        self.maxValue = max(self.maxValue!, val!)
    }
    
    func getValue() -> Double? {
        let value = self.maxValue
        self.maxValue = -999999999999
        if value == -999999999999 {
            return nil
        }
        return value
    }
    
    
}
