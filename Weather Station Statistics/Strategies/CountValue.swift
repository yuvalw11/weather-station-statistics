//
//  CountVal.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class CountValue: ValueCollectionProtocol {
    
    
    var count: Int
    var attInRecord: String
    var predicate: (Double) -> Bool
    var name: String
    
    init(name: String, attInRecord: String, predicate: @escaping (Double) -> Bool) {
        self.count = 0
        self.attInRecord = attInRecord
        self.predicate = predicate
        self.name = name
    }
    
    func getName() -> String {
        return self.name
    }
    
    
    func addRecord(record: Record) {
        let val = record.getValue(att: self.attInRecord)
        if val == nil {
            return
        }
        if self.predicate(val!) {
            self.count += 1
        }
    }
    
    func getValue() -> Double? {
        let value = self.count
        self.count = 0
        return Double(value)
    }
}

