//
//  CSVToRecords.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 20/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class CSVToRecords: FileToRecordsProtocol {
    
    private var attMapper: Dictionary<ParameterType, Int>
    
    init(attMapper: Dictionary<ParameterType, Int>) {
        self.attMapper = attMapper
    }
    
    func fileToRecord(file: URL) -> [Record] {
        var records = Array<Record>()
        do {
            var text = try String(contentsOf: file)
            text = text.replacingOccurrences(of: "\r\n", with: "\n")
            let lines = text.components(separatedBy: "\n")
            
            for line in lines.suffix(from: 1) {
                if line == "" {
                    continue
                }
                let newRecord = self.lineToRecordTSV(line: line)
                records.append(newRecord)
            }
            
            
        }
        catch {/* error handling here */}
        
        return records
    }
    
    private func isCsv(line: String) -> Bool {
        return line.contains(",")
    }
    
    private func lineToRecordTSV(line: String) -> Record {
        var values: Dictionary<String, Double> = [:]
        let subRecords: [Record] = []
        let words = line.components(separatedBy: "\t")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm d/M/yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: words[self.attMapper[.Time]!])!
        
        for (att, index) in self.attMapper {
            if att == .Time {
                continue
            }
            if Double(words[index]) == nil {
                values[att.rawValue] = nil
            } else {
                values[att.rawValue] = Double(words[index])
            }
        }
        return Record(values: values, date: date, subRecords: subRecords)
    }
    
    private func lineToRecordCSV(line: String) -> Record {
        var values: Dictionary<String, Double> = [:]
        let subRecords: [Record] = []
        let words = line.components(separatedBy: ",")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: words[self.attMapper[.Time]!])!
        
        for (att, index) in self.attMapper {
            if att == .Time {
                continue
            }
            if Double(words[index]) == nil {
                values[att.rawValue] = nil
            } else {
                values[att.rawValue] = Double(words[index])
            }
        }
        return Record(values: values, date: date, subRecords: subRecords)
    }
    
}
