//
//  YearGraphHandler.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class YearGraphHandlerConfiguration: GraphHandlerConfiguration {
    
    let days: DBStatement
    let months: DBStatement
    
    init(daysStatement: DBStatement, monthsStatement: DBStatement) {
        self.days = daysStatement
        self.months = monthsStatement
    }
    
    var statements: Dictionary<String, DBStatement> {
        return [
            "By day": self.days,
            "By month": self.months
        ]
    }
    
    var statementToXConfig: Dictionary<String, XConfiguration> {
        return [
            "By day": self.xConfigurationForStatement(statementKey: "By day"),
            "By month": self.xConfigurationForStatement(statementKey: "By month")
        ]
    }
    
    var statementToDataTypes: Dictionary<String, [String]> {
        return [
            "By day": ["Temperature day", "Rain day"],
            "By month": ["Temperature month", "Rain month"]
        ]
    }
    
    var dataTypeToDescription: Dictionary<String, String> {
        [
            "Temperature day": "Temperature",
            "Temperature month": "Temperature",
            "Rain day": "Rain",
            "Rain month": "Rain"
        ]
    }
    
    var dataTypes: Dictionary<String, [String]> {
        return [
            "Temperature day": ["OutTempMax", "OutTempMin"],
            "Rain day": ["DailyRain"],
            "Temperature month": ["AvgOutTempMax", "AvgOutTempMin"],
            "Rain month": ["MonthlyRain"]
        ]
    }
    
    var dataTypesToGraphType: Dictionary<String, GraphType> {
        return [
            "Temperature day": .Line,
            "Rain day": .Bar,
            "Temperature month": .Line,
            "Rain month": .Bar,
        ]
    }
    
    var dataTypeToYConfig: Dictionary<String, YConfiguration> {
        return [
            "Temperature day": self.yConfigurationForDataType(dataType: "Temperature day", colors: [.red, .blue], statement: self.days),
            "Rain day": self.yConfigurationForDataType(dataType: "Rain day", colors: [.blue], statement: self.days),
            "Temperature month": self.yConfigurationForDataType(dataType: "Temperature month", colors: [.red, .blue], statement: self.months),
            "Rain month": self.yConfigurationForDataType(dataType: "Rain month", colors: [.blue], statement: self.months)
        ]
    }
    
    var titleDateFormat: String {
        return "yyyy"
    }
    
    var xLabelsDateFormats: Dictionary<String, String> {
        return [
            "By day": "d/M",
            "By month": "MMM"
        ]
    }
    
}
