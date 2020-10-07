//
//  GraphViewController.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 25/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Charts

class GraphViewController: NSViewController
{
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var titleLabel: NSTextField!
    
    private var firstLoad = true
    private var graph: GraphProtocol? = nil
    
    override func viewDidAppear() {
        self.view.window?.title = "Weather Station Statistics"
    }
    
    override open func viewDidLoad() {
        self.lineChartView.doubleTapToZoomEnabled = false
        self.lineChartView.drawBordersEnabled = true
        self.lineChartView.xAxis.labelPosition = XAxis.LabelPosition(rawValue: 1)!
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        self.lineChartView.backgroundColor = NSUIColor.white
        self.lineChartView.scaleYEnabled = false
        self.lineChartView.scaleXEnabled = false
        self.lineChartView.xAxis.drawGridLinesEnabled = true
        self.lineChartView.xAxis.axisMaxLabels = 35
        
        self.barChartView.doubleTapToZoomEnabled = false
        self.barChartView.drawBordersEnabled = true
        self.barChartView.xAxis.labelPosition = XAxis.LabelPosition(rawValue: 1)!
        self.barChartView.rightAxis.enabled = false
        self.barChartView.gridBackgroundColor = NSUIColor.white
        self.barChartView.backgroundColor = NSUIColor.white
        self.barChartView.scaleYEnabled = false
        self.barChartView.scaleXEnabled = false
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.axisMinimum = 0
        self.barChartView.xAxis.axisMaxLabels = 35
        
        if self.graph != nil {
            updateView()
        }
    }
    
    func updateView() {
        self.titleLabel.backgroundColor = NSColor.white
        self.loadGraph()
        if self.firstLoad == true {
            self.lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
            //            self.firstLoad = false
        }
    }
    
    func setGraph(graph: GraphProtocol?) {
        self.graph = graph
        if self.isViewLoaded {
            self.loadGraph()
        }
    }
    
    func deleteGraph() {
        self.lineChartView.data = nil
        self.barChartView.data = nil
        self.titleLabel.stringValue = ""
    }
    
    private func getXArraysForSet(yValues: [Double?]) -> [[Int]] {
        var xArrays = Array<Array<Int>>()
        var i = 0
        var nextNillIndex = yValues.index(of: nil)
        
        while nextNillIndex != nil {
            let j = nextNillIndex!
            xArrays.append(Array(i..<j))
            i = yValues[j..<yValues.count].firstIndex{$0 != nil}!
            nextNillIndex = yValues[i..<yValues.count].index(of: nil)
        }
        
        xArrays.append(Array(i..<yValues.count))
        
        return xArrays
    }
    
    func loadGraph() {
        self.titleLabel.stringValue = (graph?.getTitle())!
        let xSize = graph!.getXLabels().count
        if graph!.getType() == .Line {
            self.barChartView.isHidden = true
            self.lineChartView.isHidden = false
            let colors = self.graph!.getColors()
            let data = LineChartData()
            for (i, trend) in (graph?.getTrends())!.enumerated() {
                let ys = trend.getYValues()
                let xArrays = self.getXArraysForSet(yValues: ys)
                for xValues in xArrays {
                    let yse = xValues.map{ChartDataEntry(x: Double($0), y: ys[$0]!)}
                    let ds = LineChartDataSet(values: yse, label: trend.getName())
                    ds.colors = [colors[i % colors.count]]
                    ds.circleRadius = 4
                    ds.circleColors = [colors[i % colors.count]]
                    ds.drawValuesEnabled = true
                    ds.drawVerticalHighlightIndicatorEnabled = true
                    ds.drawHorizontalHighlightIndicatorEnabled = true
                    data.addDataSet(ds)
                }
            }
            let formatter = DateAxisValueFormatter(labels: graph!.getXLabels())
            self.lineChartView.xAxis.valueFormatter = formatter
            if xSize < self.lineChartView.xAxis.axisMaxLabels {
                self.lineChartView.xAxis.setLabelCount(xSize - 1, force: false)
            } else {
                self.lineChartView.xAxis.setLabelCount(15, force: false)
            }
            self.lineChartView.data = data
            let max = graph?.getYMaxValue()
            let min = graph?.getYMinValue()
            if max != nil {
                self.lineChartView.leftAxis.axisMaximum = max!
            } else {
                self.lineChartView.leftAxis.resetCustomAxisMax()
            }
            if min != nil {
                self.lineChartView.leftAxis.axisMinimum = min!
            } else {
                self.lineChartView.leftAxis.resetCustomAxisMin()
            }
//            self.lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        } else {
            self.barChartView.isHidden = false
            self.lineChartView.isHidden = true
            let colors = self.graph!.getColors()
            let data = BarChartData()
            for (i, trend) in (graph?.getTrends())!.enumerated() {
                let ys = trend.getYValues()
                let xArrays = self.getXArraysForSet(yValues: ys)
                for xValues in xArrays {
                    let yse = xValues.map{BarChartDataEntry(x: Double($0), y: ys[$0]!)}
                    let ds = BarChartDataSet(values: yse, label: trend.getName())
                    ds.colors = [colors[i % colors.count]]
                    ds.drawValuesEnabled = true
                    data.addDataSet(ds)
                }
            }
            let formatter = DateAxisValueFormatter(labels: graph!.getXLabels())
            self.barChartView.xAxis.valueFormatter = formatter
            if xSize < self.barChartView.xAxis.axisMaxLabels {
                self.barChartView.xAxis.setLabelCount(xSize - 1, force: false)
            }
            let max = graph?.getYMaxValue()
            let min = graph?.getYMinValue()
            if max != nil {
                self.barChartView.leftAxis.axisMaximum = max!
            } else {
                self.barChartView.leftAxis.resetCustomAxisMax()
            }
            if min != nil {
                self.barChartView.leftAxis.axisMinimum = min!
            } else {
                self.barChartView.leftAxis.axisMinimum = 0
            }
            self.barChartView.data = data
//            self.barChartView.animate(yAxisDuration: 0.5)
        }
        
    }
    
    @IBAction func dataTypePresentaionPopUpButtonPressed(_ sender: Any) {
        self.loadGraph()
    }
    
    @IBAction func PresentationMethodPopUpButtonPressed(_ sender: Any) {
        self.loadGraph()
    }
    
    override open func viewWillAppear() {
        
    }
}

private class DateAxisValueFormatter: IAxisValueFormatter {
    
    var labels: [String]
    
    init(labels: [String]) {
        self.labels = labels
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value > 0 && value < Double(self.labels.count) {
            return self.labels[Int(value)]
        } else {
            return self.labels[0]
        }
        
    }
}
