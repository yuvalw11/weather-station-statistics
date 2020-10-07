//
//  NowRecordResponse.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 05/07/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class NowRecordResponse: ResponseProtocol {
    
    static var identifier: String = "NOWRECORD"
    
    var nowRecord: WeatherRecord;
    
    required init(data: Data) {
        let time: Date = Date(timeIntervalSinceNow: 0)
        var valuesDict = Dictionary<WeatherField, Double>()
        valuesDict[.outTemp] = NowRecordResponse.extractFloat(data: data, index: 16)
        valuesDict[.inTemp] = NowRecordResponse.extractFloat(data: data, index: 4)
        valuesDict[.outHumidity] = NowRecordResponse.extractByte(data: data, index: 3)
        valuesDict[.inHumidity] = NowRecordResponse.extractByte(data: data, index: 2)
        valuesDict[.abs] = NowRecordResponse.extractFloat(data: data, index: 8)
        valuesDict[.rel] = NowRecordResponse.extractFloat(data: data, index: 12)
        valuesDict[.dew] = NowRecordResponse.extractFloat(data: data, index: 20)
        valuesDict[.windChill] = NowRecordResponse.extractFloat(data: data, index: 24)
        valuesDict[.wind] = NowRecordResponse.extractFloat(data: data, index: 28)
        valuesDict[.windDirection] = NowRecordResponse.extractWord(data: data, index: 0)
        valuesDict[.gust] = NowRecordResponse.extractFloat(data: data, index: 32)
        valuesDict[.dailyRain] = NowRecordResponse.extractFloat(data: data, index: 40)
        valuesDict[.weeklyRain] = NowRecordResponse.extractFloat(data: data, index: 44)
        valuesDict[.monthlyRain] = NowRecordResponse.extractFloat(data: data, index: 48)
        valuesDict[.yearlyRain] = NowRecordResponse.extractFloat(data: data, index: 52)
        valuesDict[.uvi] = NowRecordResponse.extractByte(data: data, index: 60)
        valuesDict[.radiation] = NowRecordResponse.extractFloat(data: data, index: 56)
        
        self.nowRecord = WeatherRecord(time: time, values: valuesDict)
    }
    
    static func extractFloat(data: Data, index: Int) -> Double {
        return Double(Float(bitPattern: UInt32(littleEndian: data.subdata(in: index..<index + 4).withUnsafeBytes { $0.load(as: UInt32.self) })))
    }
    
    static func extractByte(data: Data, index: Int) -> Double {
        return Double(Int(data[index]))
    }
    
    static func extractWord(data: Data, index: Int) -> Double {
        let num = UInt16(littleEndian: data.subdata(in: index..<index + 2).withUnsafeBytes { $0.load(as: UInt16.self) })
        return Double(num)
    }
}
