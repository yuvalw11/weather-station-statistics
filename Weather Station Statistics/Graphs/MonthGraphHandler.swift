//
//  GraphHandler.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 16/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class MonthGraphHandlerConfiguration: GraphHandlerConfiguration {
    
    let days: DBStatement
    
    init(daysStatement: DBStatement) {
        self.days = daysStatement
    }
    
    var statements: Dictionary<String, DBStatement> {
        return [
            "By day": self.days
        ]
    }
    
    var statementToXConfig: Dictionary<String, XConfiguration> {
        return [
            "By day": self.xConfigurationForStatement(statementKey: "By day")
        ]
    }
    
    var statementToDataTypes: Dictionary<String, [String]> {
        return [
            "By day": ["Temperature", "Humidity", "Rain", "UV", "Radiation", "Max wind speed"]
        ]
    }
    
    var dataTypes: Dictionary<String, [String]> {
        return [
            "Temperature": ["OutTempMax", "OutTempMin"],
            "Humidity": ["OutHumMax", "OutHumMin"],
            "Rain": ["DailyRain"],
            "UV": ["UVIMax"],
            "Radiation": ["RadiationMax"],
            "Max wind speed": ["GustSpeedMax"]
        ]
    }
    
    var dataTypesToGraphType: Dictionary<String, GraphType> {
        return [
            "Temperature": .Line,
            "Humidity": .Line,
            "Rain": .Bar,
            "UV": .Bar,
            "Radiation": .Bar,
            "Max wind speed": .Bar
        ]
    }
    
    var dataTypeToYConfig: Dictionary<String, YConfiguration> {
        return [
            "Temperature": self.yConfigurationForDataType(dataType: "Temperature", colors: [.red, .blue], statement: self.days),
            "Humidity": self.yConfigurationForDataType(dataType: "Humidity", colors: [.blue, .cyan], statement: self.days),
            "Rain": self.yConfigurationForDataType(dataType: "Rain", colors: [.blue], statement: self.days),
            "UV": self.yConfigurationForDataType(dataType: "UV", colors: [.purple], statement: self.days),
            "Radiation": self.yConfigurationForDataType(dataType: "Radiation", colors: [.orange], statement: self.days),
            "Max wind speed": self.yConfigurationForDataType(dataType: "Max wind speed", colors: [.darkGray], statement: self.days)
        ]
    }
    
    var titleDateFormat: String {
        return "MMM - yyyy"
    }
    
    var xLabelsDateFormats: Dictionary<String, String> {
        return [
            "By day": "d"
        ]
    }
    
}
