//
//  ParameterConverter.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 27/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol ParameterConverter {
    func fromUnit() -> String
    func toUnit() -> String
    func convert(val: Double) -> Double
}
