//
//  GraphHandler.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class GraphHandler: GraphHandlingProtocol {
    
    let config: GraphHandlerConfiguration
    
    init(handlerConfig: GraphHandlerConfiguration) {
        self.config = handlerConfig
    }
    
    func getGraph(period: String, Data: String, ymax: Double?, ymin: Double?) -> GraphProtocol? {
        let statement = self.config.statements[period]!
        let xConfig = self.config.statementToXConfig[period]!
        let yConfig = self.config.dataTypeToYConfig[Data]!
        let columns = self.config.dataTypes[Data]!
        
        let mainTitle = "\(Data)  \(self.config.getTitle(dates: statement.Records.map{$0.date}))"
        
        let graph = Graph(type: self.config.dataTypesToGraphType[Data]!, mainTitle: mainTitle)
        
        let records = statement.Records
        for column in columns {
            var yValues: [Double?] = Array()
            records.forEach{yValues.append($0[column])}
            graph.addTrend(trend: Trend(name: column, yValues: yValues))
        }
        
        graph.setXConfiguration(xConfig: xConfig)
        graph.setYConfiguration(yConfig: YConfiguration(yLabel: yConfig.yLabel, yMax: ymax, yMin: ymin, colors: yConfig.colors, trends: yConfig.trends))
        return graph
    }
    
    func getPeriodDomain() -> [String] {
        return Array(self.config.statements.keys).sorted()
    }
    
    func getDataDomainForPeriod(period: String) -> [String] {
        return self.config.statementToDataTypes[period]!
    }
    
}

protocol GraphHandlerConfiguration {
    var statements: Dictionary<String, DBStatement> {get}
    var statementToXConfig: Dictionary<String, XConfiguration>{get}
    var statementToDataTypes: Dictionary<String, [String]>{get}
  
    var dataTypes: Dictionary<String, [String]>{get}
    var dataTypesToGraphType: Dictionary<String, GraphType>{get}
    var dataTypeToYConfig: Dictionary<String, YConfiguration> {get}
    
    var titleDateFormat: String {get}
    var xLabelsDateFormats: Dictionary<String, String> {get}
}

extension GraphHandlerConfiguration {
    func getTrends(_ statement: DBStatement, _ fields: [String]) -> [Trend] {
        var trends: [Trend] = Array()
        for field in fields {
            trends.append(Trend(name: field, yValues: statement.Records.map{$0[field]}))
        }
        return trends
    }
    
    func yConfigurationForDataType(dataType: String, colors: [NSColor], statement: DBStatement) -> YConfiguration {
        return YConfiguration(yLabel: dataType, yMax: nil, yMin: nil, colors: colors, trends: self.getTrends(statement, self.dataTypes[dataType]!))
    }
    
    func xConfigurationForStatement(statementKey: String) -> XConfiguration {
        let dates = self.statements[statementKey]!.Records.map{$0.date}
        return XConfiguration(xLabel: statementKey, xLabels: dates.map{self.xLabelsDateFormatters[statementKey]!.string(from: $0)}, xValues: dates.map{$0.timeIntervalSince1970})
    }
    
    var titleDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = self.titleDateFormat
        return formatter
    }
    
    var xLabelsDateFormatters: Dictionary<String, DateFormatter> {
        var formatters = Dictionary<String, DateFormatter>()
        for (key, format) in self.xLabelsDateFormats {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = format
            formatters[key] = formatter
        }
        return formatters
    }
    
    func getTitle(dates: [Date]) -> String {
        let min = self.titleDateFormatter.string(from: dates.min()!)
        let max = self.titleDateFormatter.string(from: dates.max()!)
        
        if min == max {
            return min
        } else {
            return "\(min)-\(max)"
        }
    }
    
}
