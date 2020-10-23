//
//  DayGraphHandler.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class DayGraphHandlerConfiguration: GraphHandlerConfiguration {
    
    let records: DBStatement
    
    init(recordsStatement: DBStatement) {
        self.records = recordsStatement
    }
    
    var statements: Dictionary<String, DBStatement> {
        return [
            "By record": self.records
        ]
    }
    
    var statementToXConfig: Dictionary<String, XConfiguration> {
        return [
            "By record": self.xConfigurationForStatement(statementKey: "By record")
        ]
    }
    
    var statementToDataTypes: Dictionary<String, [String]> {
        return [
            "By record": ["Temperature", "Humidity", "Dew point", "Rain", "Wind", "Radiation", "UV"]
        ]
    }
    
    var dataTypes: Dictionary<String, [String]> {
        return [
            "Temperature": ["OutTemp"],
            "Humidity": ["OutHum"],
            "Dew point": ["DewPoint"],
            "Rain": ["DailyRain", "RainRate"],
            "Wind": ["WindSpeed"],
            "Radiation": ["Radiation"],
            "UV": ["UVI"]
        ]
    }
    
    var dataTypesToGraphType: Dictionary<String, GraphType> {
        return [
            "Temperature": .Line,
            "Humidity": .Line,
            "Dew point": .Line,
            "Rain": .Line,
            "Wind": .Line,
            "Radiation": .Line,
            "UV": .Line
        ]
    }
    
    var dataTypeToYConfig: Dictionary<String, YConfiguration> {
        return [
            "Temperature": self.yConfigurationForDataType(dataType: "Temperature", colors: [.red], statement: self.records),
            "Humidity": self.yConfigurationForDataType(dataType: "Humidity", colors: [.blue], statement: self.records),
            "Dew point": self.yConfigurationForDataType(dataType: "Dew point", colors: [.blue], statement: self.records),
            "Rain": self.yConfigurationForDataType(dataType: "Rain", colors: [.blue, .cyan], statement: self.records),
            "Wind": self.yConfigurationForDataType(dataType: "Wind", colors: [.gray, .darkGray], statement: self.records),
            "Radiation": self.yConfigurationForDataType(dataType: "Radiation", colors: [.orange], statement: self.records),
            "UV": self.yConfigurationForDataType(dataType: "UV", colors: [.purple], statement: self.records)

        ]
    }
    
    var titleDateFormat: String {
        return "d/M/yyyy"
    }
    
    var xLabelsDateFormats: Dictionary<String, String> {
        return [
            "By record": "HH:mm"
        ]
    }
    
}
