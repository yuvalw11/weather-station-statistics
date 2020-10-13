//
//  MonthPresentaion.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 16/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class MonthPresentation: StaticPresentationProtocol {    
    
    private var monthRecord: DBRecord
    private var dayStatement: DBStatement
    
    init(monthRecord: DBRecord, dayStatement: DBStatement) {
        self.monthRecord = monthRecord
        self.dayStatement = dayStatement
    }
    
    func getTitle() -> String {
        let dateFormatterTitle = DateFormatter()
        dateFormatterTitle.dateFormat = "MMMM - yyyy"
        dateFormatterTitle.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatterTitle.string(from: self.monthRecord.date)
    }
    
    func getLeftText() -> String {
        let avgMaxTemp = self.valueToString(val: self.monthRecord["AvgOutTempMax"], roundBy: 10)
        let avgMinTemp = self.valueToString(val: self.monthRecord["AvgOutTempMin"], roundBy: 10)
        let avgREL = self.valueToString(val: self.monthRecord["RelAvg"], roundBy: 10)
        let avgMaxRad = self.valueToString(val: self.monthRecord["RadiationMaxAvg"], roundBy: 10)
        let avgMaxUVI = self.valueToString(val: self.monthRecord["UVIMaxAvg"], roundBy: 10)
        let rainAccum = self.valueToString(val: self.monthRecord["MonthlyRain"], roundBy: 10)
        
        let maxTemp = self.valueToString(val: self.monthRecord["OutTempMax"], roundBy: 10)
        let minTemp = self.valueToString(val: self.monthRecord["OutTempMin"], roundBy: 10)
        let maxWindSpeed = self.valueToString(val: self.monthRecord["GustSpeedMax"], roundBy: 10)
        let maxRel = self.valueToString(val: self.monthRecord["RelMax"], roundBy: 10)
        let minRel = self.valueToString(val: self.monthRecord["RelMin"], roundBy: 10)
        let maxRainRate = self.valueToString(val: self.monthRecord["RainRateMax"], roundBy: 10)
        let maxRad = self.valueToString(val: self.monthRecord["RadiationMax"], roundBy: 10)
        let maxUV = self.valueToString(val: self.monthRecord["UVIMax"], roundBy: 10)
//        let rainSpan = self.valueToString(val: self.record["rainSpan"]!/ 3600, roundBy: 10)
        let tempDiff = self.valueToString(val: self.monthRecord["TempDiffMax"], roundBy: 10)
        
        
        var str: String = ""
        str += "Tepmerature: " + avgMaxTemp + "° - " + avgMinTemp + "°\n"
        str += "Average Presure: " + avgREL + "\n"
        str += "Avrage Maximum Radiation: " + avgMaxRad + "\n"
        str += "Average Maximum UV: " + avgMaxUVI + "\n"
//        str += "Time of Rain: " + rainSpan + " hours\n"
        str += "Rain Accumulation: " + rainAccum + "\n\n"
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
        let rainyDaysNum = self.monthRecord["NumberOfRainyDays"]
        let hotDaysNum = self.monthRecord["NumberOfHotDays"]
        let amountOfMeasures = self.monthRecord["Measurements"]
        let rainyDaysNumStr = String(Int(rainyDaysNum!))
        let hotDaysNumStr = String(Int(hotDaysNum!))
        let amountOfMeasuresStr = String(Int(amountOfMeasures!))
        
        return "Amount of rainy days: " + rainyDaysNumStr + "\n" + "Amount of hot days: " + hotDaysNumStr + "\n" + "Amount of measures: " + amountOfMeasuresStr
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        let configuration = MonthGraphHandlerConfiguration(daysStatement: self.dayStatement)
        return GraphHandler(handlerConfig: configuration)
    }
    
    private func valueToString(val: Double?, roundBy: Int) -> String {
        if val == nil {
            return "--"
        } else {
            return String(round(val!*Double(roundBy))/Double(roundBy))
        }
    }
    
}
