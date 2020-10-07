//
//  HistoryFileResponse.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 04/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

internal class HistoryFileResponse : ResponseProtocol {
    
    static var identifier: String = "HISTORY_FILE"
    
    private static let segmentSize = 48
    private static let amountOfFieldsPerSegment = 8
    private static let fileFieldSize = 2
    private static let numFieldSize = 4
    
    private var fileMapper: Dictionary<Int, Int>
    
    required init(data: Data) {
        self.fileMapper = Dictionary()
        
        for segmentIndex in 0..<((data.count) / HistoryFileResponse.segmentSize) {
            let lowBoundry = segmentIndex * HistoryFileResponse.segmentSize
            let highBoundry = (segmentIndex + 1) * HistoryFileResponse.segmentSize
            let mapperToAdd = self.handleSegment(data: data.subdata(in: lowBoundry..<highBoundry))
            self.fileMapper.merge(mapperToAdd, uniquingKeysWith: {
                (old: Int, new: Int) -> Int in
                return -1
            })
        }
    }
    
    private func handleSegment(data: Data) -> Dictionary<Int, Int> {
        var fileMapper = Dictionary<Int, Int>()
        for fieldIndex in 0...HistoryFileResponse.amountOfFieldsPerSegment {
            
            let recordsNumOffset = HistoryFileResponse.amountOfFieldsPerSegment * HistoryFileResponse.fileFieldSize
            let yearLowBoundry = fieldIndex * HistoryFileResponse.fileFieldSize
            let yearHighBoundry = (fieldIndex + 1) * HistoryFileResponse.fileFieldSize
            let recordsNumLowBoundry = recordsNumOffset + fieldIndex * HistoryFileResponse.numFieldSize
            let recordsNumHighBoundry = recordsNumOffset + (fieldIndex + 1) * HistoryFileResponse.numFieldSize
            
            let year = Int(littleEndian: data.subdata(in: yearLowBoundry..<yearHighBoundry).withUnsafeBytes{$0.pointee})
            let recordsNum = Int(littleEndian: data.subdata(in: recordsNumLowBoundry..<recordsNumHighBoundry).withUnsafeBytes{$0.pointee})
            
            if year == 0 {
                break
            }
            
            fileMapper[year] = recordsNum
        }
        
        return fileMapper
    }
    
    func getNumberOfRecordsForFile(file: Int) -> Int? {
        return self.fileMapper[file]
    }
    
    var files: Array<Int> {
        get {
            return Array(self.fileMapper.keys)
        }
    }
    
}
