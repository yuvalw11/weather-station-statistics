//
//  RainSeasonGraphHandler.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 02/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class RainSeasonGraphHandlerConfiguration: GraphHandlerConfiguration {
    
    let months: DBStatement
    
    init(monthsStatement: DBStatement) {
        self.months = monthsStatement
    }
    
    var statements: Dictionary<String, DBStatement> {
        return [
            "By month": self.months
        ]
    }
    
    var statementToXConfig: Dictionary<String, XConfiguration> {
        return [
            "By month": self.xConfigurationForStatement(statementKey: "By month")
        ]
    }
    
    var statementToDataTypes: Dictionary<String, [String]> {
        return [
            "By month": ["Rain", "Number of Rainy Days"]
        ]
    }
    
    var dataTypes: Dictionary<String, [String]> {
        return [
            "Rain": ["MonthlyRain"],
            "Number of Rainy Days": ["NumberOfRainyDays"]
        ]
    }
    
    var dataTypesToGraphType: Dictionary<String, GraphType> {
        return [
            "Rain": .Bar,
            "Number of Rainy Days": .Bar
        ]
    }
    
    var dataTypeToYConfig: Dictionary<String, YConfiguration> {
        return [
            "Rain": self.yConfigurationForDataType(dataType: "Rain", colors: [.blue], statement: self.months),
            "Number of Rainy Days": self.yConfigurationForDataType(dataType: "Number of Rainy Days", colors: [.blue], statement: self.months)
        ]
    }
    
    var titleDateFormat: String {
        return "yyyy"
    }
    
    var xLabelsDateFormats: Dictionary<String, String> {
        return [
            "By month": "MMM/yyyy"
        ]
    }
    
}
