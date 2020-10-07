//
//  HistoryDataResponse.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 06/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class HistoryDataResponse : ResponseProtocol {
    
    static var identifier: String = "HISTORY_DATA"

    private static var epoch = Date(timeIntervalSince1970: -11644473600)
    private static let extractors: [DataExtractionProtocol] = [
        InTempExtractor(),
        InHumidityExtractor(),
        OutTempExtractor(),
        OutHumidityExtractor(),
        ChillExtractor(),
        DewExtractor(),
        HeatIndexExtractor(),
        RelExtractor(),
        AbsExtractor(),
        WindExtractor(),
        GustExtractor(),
        WindDirectionExtractor(),
        RainRateExtractor(),
        DailyRainExtractor(),
        WeeklyRainExtractor(),
        MonthlyRainExtractor(),
        YearlyRainExtractor(),
        UviRExtractor(),
        RadiationRExtractor()
    ]
    
    var records: [Record]
    
    required init(data: Data) {
        self.records = Array<Record>()
        let amountOfRecords = (data.count) / 60
        
        for i in 0..<amountOfRecords {
            self.records.append(self.parseRecord(data: data.subdata(in: (i*60)..<((i+1)*60))))
        }
    }
    
    private func parseRecord(data: Data) -> Record {
        var time: Date
        var valuesDict = Dictionary<String, Double>()
        
        let rawDateNumber = UInt64(littleEndian: data.subdata(in: 0..<8).withUnsafeBytes{$0.pointee})
        let value = Double(rawDateNumber) / 10000000
        time = Date(timeInterval: value, since: HistoryDataResponse.epoch)
        
        for extractor in HistoryDataResponse.extractors {
            let data = extractor.extract(binary: data)
            if data != nil {
                valuesDict[extractor.weatherField] = data
            }
        }
        
        return Record(values: valuesDict, date: time, subRecords: [])
    }
    
    
}

