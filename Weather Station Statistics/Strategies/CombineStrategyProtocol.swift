//
//  CombineStrategyProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 15/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol CombineStrategyProtocol {
    func getGroupDateForDate(date: Date) -> Date
    func getValues() -> [ValueCollectionProtocol]
}
