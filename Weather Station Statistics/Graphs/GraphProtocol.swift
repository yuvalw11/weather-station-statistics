//
//  GraphProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

protocol GraphProtocol {
    func getTitle() -> String
    func getXValues() -> [Double]
    func getType() -> GraphType
    func getTrends() -> [Trend]
    func getXLabel() -> String?
    func getYLabel() -> String?
    func getXLabelsFormat() -> String
    func getXLabels() -> [String]
    func getColors() -> [NSColor]
    func getYMaxValue() -> Double?
    func getYMinValue() -> Double?
}

enum GraphType {
    case Line
    case Bar
}
