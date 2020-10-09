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
    
    override var dateColumn: Expression<Date> {
        return Expression<Date>("Date").rangeByMonth(month: Int64(ApplicationSetup.rainSeasonStartMonth))
    }
    
    override var expressionsMapper: Dictionary<String, Expression<Double?>> {
        return [
            "RainRateMax": Expression<Double?>("RainRateMax").max,
            "SeasonalRain": Expression<Double?>("MonthlyRain").sum,
            "NumberOfRainyDays": Expression<Double?>("NumberOfRainyDays").sum
        ]
    }
}

