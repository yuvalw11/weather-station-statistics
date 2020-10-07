//
//  RainSeasonGraphHandler.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 02/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class RainGraphHandlerConfiguration: GraphHandlerConfiguration {
    
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
            "By month": ["Rain"]
        ]
    }
    
    var dataTypes: Dictionary<String, [String]> {
        return [
            "Rain": ["MonthlyRain"]
        ]
    }
    
    var dataTypesToGraphType: Dictionary<String, GraphType> {
        return [
            "Rain": .Bar
        ]
    }
    
    var dataTypeToYConfig: Dictionary<String, YConfiguration> {
        return [
            "Rain": self.yConfigurationForDataType(dataType: "Rain", colors: [.blue], statement: self.months)
        ]
    }
    
    var titleDateFormat: String {
        return "yyyy"
    }
    
    var xLabelsDateFormats: Dictionary<String, String> {
        return [
            "By month": "MMM"
        ]
    }
    
}
