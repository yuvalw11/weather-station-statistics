//
//  RecordsTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 21/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class RecordsTable: DBTable, TableProtocol {
     
   override var query: Table {
        get {
            return Table("Records")
        }
    }
    
    override var fieldNames: Array<String> {
        return [
        "InTemp",
        "InHum",
        "OutTemp",
        "OutHum",
        "Abs",
        "Rel",
        "WindSpeed",
        "GustSpeed",
        "WindDirection",
        "WindChill",
        "DewPoint",
        "HeatIndex",
        "RainRate",
        "DailyRain",
        "WeeklyRain",
        "MonthlyRain",
        "YearlyRain",
        "Radiation",
        "UVI"
        ]
    }
}
