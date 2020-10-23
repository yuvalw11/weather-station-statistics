//
//  DayPresentation.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class DayPresentation: StaticPresentationProtocol {
    
    private var dayRecord: DBRecord
    private var recordsStatement: DBStatement
    
    init(dayRecord: DBRecord, recordsStatement: DBStatement) {
        self.dayRecord = dayRecord
        self.recordsStatement = recordsStatement
    }
    
    func getTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self.dayRecord.date)
    }
    
    func getLeftText() -> String {
        let avgREL = self.valueToString(val: self.dayRecord["RelAvg"], roundBy: 10)
        let rainAccum = self.valueToString(val: self.dayRecord["DailyRain"], roundBy: 10)
        
        let maxTemp = self.valueToString(val: self.dayRecord["OutTempMax"], roundBy: 10)
        let minTemp = self.valueToString(val: self.dayRecord["OutTempMin"], roundBy: 10)
        let maxDew = self.valueToString(val: self.dayRecord["DewPointMax"], roundBy: 10)
        let minDew = self.valueToString(val: self.dayRecord["DewPointMin"], roundBy: 10)
        let maxHum = String(Int(self.dayRecord["OutHumMax"]!))
        let minHum = String(Int(self.dayRecord["OutHumMin"]!))
        let maxWindSpeed = self.valueToString(val: self.dayRecord["GustSpeedMax"], roundBy: 10)
        let maxRel = self.valueToString(val: self.dayRecord["RelMax"], roundBy: 10)
        let minRel = self.valueToString(val: self.dayRecord["RelMin"], roundBy: 10)
        let maxRainRate = self.valueToString(val: self.dayRecord["RainRateMax"], roundBy: 10)
        let maxRad = self.valueToString(val: self.dayRecord["RadiationMax"], roundBy: 10)
        let maxUV = self.valueToString(val: self.dayRecord["UVIMax"], roundBy: 10)
        let maxHeatIndex = self.valueToString(val: self.dayRecord["HeatIndexMax"], roundBy: 1)
//        let rainSpan = self.valueToString(val: self.dayRecord["rainSpan"]! / 60, roundBy: 10)
        
        var str: String = ""
        str += "Tepmerature: " + maxTemp + "° - " + minTemp + "°\n"
        str += "Humidity: " + maxHum + "% - " + minHum + "%\n"
        str += "Dew Point: " + maxDew + "° - " + minDew + "°\n"
        str += "Average Presure: " + avgREL + "\n"
//        str += "Time of Rain: " + rainSpan + " minuets\n"
        str += "Rain Accumulation: " + rainAccum + "\n\n"
        str += "Maximum Wind Speed: " + maxWindSpeed + "\n"
        str += "Maximum Presure: " + maxRel + "\n"
        str += "Minimum Presure: " + minRel + "\n"
        str += "Maximum Rain Rate: " + maxRainRate + "\n"
        str += "Maximum Radiaition: " + maxRad + "\n"
        str += "Maximum UV: " + maxUV + "\n"
        str += "Maximum Heat Index: " + maxHeatIndex
    
        return str
    }
    
    func getCenterText() -> String {
        let amountOfMeasures = self.dayRecord["Measurements"]
        let amountOfMeasuresStr = String(Int(amountOfMeasures!))
        return "Amount of measures: \(amountOfMeasuresStr)"
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        let handlerConfig = DayGraphHandlerConfiguration(recordsStatement: self.recordsStatement)
        return GraphHandler(handlerConfig: handlerConfig)
    }
    
    private func valueToString(val: Double?, roundBy: Int) -> String {
        if val == nil {
            return "--"
        } else {
            return String(round(val!*Double(roundBy))/Double(roundBy))
        }
    }
    
}
