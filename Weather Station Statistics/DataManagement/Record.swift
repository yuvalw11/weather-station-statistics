//
//  Record.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class Record {
    
    private let date: Date
    private var values: Dictionary<String, Double>
    private var subRecords: [Record]
    private var amountOfMeasures: Int
    
    init(values: Dictionary<String, Double>, date: Date, subRecords: [Record]) {
        self.values = values
        self.date = date
        self.subRecords = subRecords
        if subRecords.isEmpty {
            self.amountOfMeasures = 1
        } else {
            self.amountOfMeasures = 0
            for sub in subRecords {
                self.amountOfMeasures += sub.amountOfMeasures
            }
        }
    }
    
    func getAmountOfMeasures() -> Int {
        return self.amountOfMeasures
    }
    
    func getValue(att: String) -> Double? {
        return self.values[att]
    }
    
    func getDate() -> Date {
        return self.date
    }
    
    func getSubRecords() -> [Record] {
        return self.subRecords
    }
}
