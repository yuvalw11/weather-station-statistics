//
//  RainSeasonTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 28/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class RainSeasonTable: DBQuery, TableProtocol {
    
    override var expressionsMapper: Dictionary<String, Expression<Double?>> {
        return [
            "RainRateMax": Expression<Double?>("RainRate").max,
            "SeasonalRain": Expression<Double?>("YearlyRain").max,
        ]
    }
}

