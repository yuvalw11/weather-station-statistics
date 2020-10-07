//
//  Configuration.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/04/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class XConfiguration {
    let xValues: [Double]
    let xLabels: [String]
    let xLabel: String
    
    init(xLabel: String, xLabels: [String], xValues: [Double]) {
        self.xLabels = xLabels
        self.xValues = xValues
        self.xLabel = xLabel
    }
}

class YConfiguration {
    let yLabel: String
    let yMax: Double?
    let yMin: Double?
    let colors: [NSColor]
    var trends: [Trend]
    
    init(yLabel: String, yMax: Double?, yMin: Double?, colors: [NSColor], trends: [Trend]) {
        self.yLabel = yLabel
        self.yMax = yMax
        self.yMin = yMin
        self.colors = colors
        self.trends = trends
    }
    
    func addTrend(trend: Trend) {
        self.trends.append(trend)
    }
}

class Trend {
    let yValues: [Double?]
    let name: String
    
    init(name: String, yValues: [Double?]) {
        self.name = name
        self.yValues = yValues
    }
    
    func getYValues() -> [Double?] {
        return self.yValues
    }
    
    func getName() -> String {
        return self.name
    }
}
