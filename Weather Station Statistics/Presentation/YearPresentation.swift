//
//  YearPresentation.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class YearPresentation: StaticPresentationProtocol {
    
    private var yearRecord: DBRecord
    private var monthsRecords: DBStatement
    private var daysRecords: DBStatement
    
    init(yearRecord: DBRecord, monthsRecords: DBStatement, daysRecords: DBStatement) {
        self.yearRecord = yearRecord
        self.monthsRecords = monthsRecords
        self.daysRecords = daysRecords
    }
    
    func getTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self.yearRecord.date)
    }
    
    func getLeftText() -> String {
        let avgMaxTemp = self.valueToString(val: self.yearRecord["AvgOutTempMax"], roundBy: 10)
        let avgMinTemp = self.valueToString(val: self.yearRecord["AvgOutTempMin"], roundBy: 10)
        let avgREL = self.valueToString(val: self.yearRecord["RelAvg"], roundBy: 10)
        let rainAccum = self.valueToString(val: self.yearRecord["MonthlyRain"], roundBy: 10)
        
        let maxTemp = self.valueToString(val: self.yearRecord["OutTempMax"], roundBy: 10)
        let minTemp = self.valueToString(val: self.yearRecord["OutTempMin"], roundBy: 10)
        let maxWindSpeed = self.valueToString(val: self.yearRecord["GustSpeedMax"], roundBy: 10)
        let maxRel = self.valueToString(val: self.yearRecord["RelMax"], roundBy: 10)
        let minRel = self.valueToString(val: self.yearRecord["RelMin"], roundBy: 10)
        let maxRainRate = self.valueToString(val: self.yearRecord["RainRateMax"], roundBy: 10)
        let maxRad = self.valueToString(val: self.yearRecord["RadiationMax"], roundBy: 10)
        let maxUV = self.valueToString(val: self.yearRecord["UVIMax"], roundBy: 10)
//        let rainSpan = self.valueToString(val: self.yearRecord["rainSpan"]! / 3600, roundBy: 10)
        let tempDiff = self.valueToString(val: self.yearRecord["TempDiffMax"], roundBy: 10)
        
        var str: String = ""
        str += "Tepmerature: " + avgMaxTemp + "° - " + avgMinTemp + "°\n"
        str += "Average Presure: " + avgREL + "\n"
//        str += "Time of Rain: " + rainSpan + " hours\n"
        str += "Rain Accumulation: " + rainAccum + "\n\n\n"
        str += "Maximum Temperature: " + maxTemp + "°\n"
        str += "Minimum Temperature: " + minTemp + "°\n"
        str += "Max Temperature diff: " + tempDiff + "°\n"
        str += "Maximum Wind Speed: " + maxWindSpeed + "\n"
        str += "Maximum Presure: " + maxRel + "\n"
        str += "Minimum Presure: " + minRel + "\n"
        str += "Maximum Rain Rate: " + maxRainRate + "\n"
        str += "Maximum Radiaition: " + maxRad + "\n"
        str += "Maximum UV: " + maxUV + "\n"
        
        return str
    }
    
    func getCenterText() -> String {
        let rainyDaysNum = self.yearRecord["NumberOfRainyDays"]
        let hotDaysNum = self.yearRecord["NumberOfHotDays"]
        let rainyDaysNumStr = String(Int(rainyDaysNum!))
        let hotDaysNumStr = String(Int(hotDaysNum!))
        let amountOfMeasures = self.yearRecord["Measurements"]
        let amountOfMeasuresStr = String(Int(amountOfMeasures!))
        
        return "Amount of rainy days: " + rainyDaysNumStr + "\n" + "Amount of hot days: " + hotDaysNumStr + "\n" + "Amount of measures: \(amountOfMeasuresStr)"
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        let handlerConfig = YearGraphHandlerConfiguration(daysStatement: self.daysRecords, monthsStatement: self.monthsRecords)
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
