//
//  HistoryDataRequest.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 06/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class HistoryDataRequest : RequestProtocol {
    static var identifier: String = "HISTORY_DATA"
    
    private var year: UInt16
    private var fromRecordNumber: Int32
    private var numberOfRecords: UInt16
    
    init(year: Int, fromRecordNumber: Int, numberOfRecords: Int) {
        self.year = UInt16(year)
        self.fromRecordNumber = Int32(fromRecordNumber)
        self.numberOfRecords = UInt16(numberOfRecords)
    }
    
    var bytes: Data {
        let yearBytes = withUnsafeBytes(of: self.year.littleEndian, Array.init)
        let numberOfRecordsBytes = withUnsafeBytes(of: self.numberOfRecords.littleEndian, Array.init)
        let fromRecordNumberBytes = withUnsafeBytes(of: self.fromRecordNumber.littleEndian, Array.init)
        
        var data = Data()
        data.append(contentsOf: yearBytes)
        data.append(contentsOf: numberOfRecordsBytes)
        data.append(contentsOf: fromRecordNumberBytes)
        
        return data
    }
    
    public var Year: Int {
        return Int(self.year)
    }
    
    public var FromRecordNumber: Int {
        return Int(self.fromRecordNumber)
    }
    
    public var NumberOfRecords: Int {
        return Int(self.numberOfRecords)
    }
}
