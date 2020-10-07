//
//  Graph.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 16/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class Graph: GraphProtocol {

    private var xValues: [Double]
    private var trends: [Trend]
    private var type: GraphType
    private var xLabel: String?
    private var yLabel: String?
    private var xLabelsFormat: String
    private var xLabels: [String]
    private var title: String
    private var colors: [NSColor]
    private var ymax: Double?
    private var ymin: Double?
    
    init(type: GraphType, mainTitle: String) {
        self.xValues = []
        self.type = type
        self.trends = []
        self.xLabel = ""
        self.yLabel = ""
        self.xLabelsFormat = ""
        self.xLabels = []
        self.title = mainTitle
        self.colors = []
        self.ymax = nil
        self.ymin = nil
    }
    
    func getColors() -> [NSColor] {
        return self.colors
    }
    
    func setXConfiguration(xConfig: XConfiguration) {
        self.xValues = xConfig.xValues
        self.xLabel = xConfig.xLabel
        self.xLabels = xConfig.xLabels
    }
    
    func setYConfiguration(yConfig: YConfiguration) {
        self.yLabel = yConfig.yLabel
        self.ymax = yConfig.yMax
        self.ymin = yConfig.yMin
        self.colors = yConfig.colors
        self.trends = yConfig.trends
    }
    
    func addTrend(trend: Trend) {
        self.trends.append(trend)
    }
    
    func getXLabelsFormat() -> String {
        return xLabelsFormat
    }
    
    func getXLabels() -> [String] {
        return self.xLabels
    }
    
    func getTrends() -> [Trend] {
        return trends
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getXValues() -> [Double] {
        return self.xValues
    }
    
    func getXLabel() -> String? {
        return self.xLabel
    }
    
    func getYLabel() -> String? {
        return self.yLabel
    }
    
    func getType() -> GraphType {
        return self.type
    }
    
    func getYMaxValue() -> Double? {
        return self.ymax
    }
    
    func getYMinValue() -> Double? {
        return self.ymin
    }
}

