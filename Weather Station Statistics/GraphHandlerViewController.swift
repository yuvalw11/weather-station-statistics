//
//  LineGraphViewController.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 16/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Charts

class GraphHandlerViewController: NSViewController
{
    
    @IBOutlet weak var minTextField: NSTextField!
    @IBOutlet weak var maxTextField: NSTextField!
    @IBOutlet weak var dataTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var presentationMethodPopUpButton: NSPopUpButton!

    private var optionsViewController: OptionsViewController? = nil
    internal var graphViewController: GraphViewController? = nil
    private var handler: GraphHandlingProtocol? = nil
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GraphViewControllerSegue") {
            let destinationVC: GraphViewController = segue.destinationController as! GraphViewController
            self.graphViewController = destinationVC
        } else if (segue.identifier == "EnlargeSegue") {
            let destinationVC: GraphViewController = segue.destinationController as! GraphViewController
            destinationVC.setGraph(graph: self.getGraph())
            destinationVC.view.resize(withOldSuperviewSize: (self.view.window?.maxSize)!)
        }
    }
    
    override func viewDidAppear() {
        
    }
    
    @IBAction func maxChanged(_ sender: NSTextField) {
        self.loadGraph()
    }
    
    
    @IBAction func minChanged(_ sender: NSTextField) {
        self.loadGraph()
    }
    
    override open func viewDidLoad() {
        self.dataTypePopUpButton.isEnabled = false
        self.presentationMethodPopUpButton.isEnabled = false
        self.maxTextField.isEnabled = false
        self.minTextField.isEnabled = false
        if self.handler != nil {
            updateView()
        }
    }
    
    func deleteGraph() {
        self.graphViewController?.deleteGraph()
    }
    
    private func updateDataTypes(presentaionMethod: String) {
        let currntDataType = self.dataTypePopUpButton.selectedItem!.title
        let newOptions = self.handler!.getDataDomainForPeriod(period: presentaionMethod)
        self.dataTypePopUpButton.removeAllItems()
        self.dataTypePopUpButton.addItems(withTitles: newOptions)
        
        if newOptions.contains(currntDataType) {
            self.dataTypePopUpButton.selectItem(withTitle: currntDataType)
        }
    }
    
    private func updatePresentationMethods() {
        let currentPresentationMethod = self.presentationMethodPopUpButton.selectedItem!.title
        let newOptions = self.handler!.getPeriodDomain()
        self.presentationMethodPopUpButton.removeAllItems()
        self.presentationMethodPopUpButton.addItems(withTitles: newOptions)
        
        if newOptions.contains(currentPresentationMethod) {
            self.presentationMethodPopUpButton.selectItem(withTitle: currentPresentationMethod)
        }
    }
    
    func updateView() {
        self.updatePresentationMethods()
        self.updateDataTypes(presentaionMethod: self.presentationMethodPopUpButton.selectedItem!.title)

        self.loadGraph()
        self.dataTypePopUpButton.isEnabled = true
        self.presentationMethodPopUpButton.isEnabled = true
        self.maxTextField.isEnabled = true
        self.minTextField.isEnabled = true
    }
    
    func setGraphHandler(handler: GraphHandlingProtocol?) {
        self.handler = handler
    }
    
    func getGraph() -> GraphProtocol {
        let graph = self.handler?.getGraph(period: (self.presentationMethodPopUpButton.selectedItem?.title)!, dataDescription: (self.dataTypePopUpButton.selectedItem?.title)!, ymax: Double(self.maxTextField.stringValue), ymin: Double(self.minTextField.stringValue))!
        return graph!
    }
    
    func loadGraph() {
        self.graphViewController?.setGraph(graph: self.getGraph())
    }
    
    @IBAction func dataTypePresentaionPopUpButtonPressed(_ sender: Any) {
        self.loadGraph()
    }
    
    @IBAction func PresentationMethodPopUpButtonPressed(_ sender: Any) {
        self.updateDataTypes(presentaionMethod: self.presentationMethodPopUpButton.selectedItem!.title)
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
        return self.labels[Int(value)]
    }
}
