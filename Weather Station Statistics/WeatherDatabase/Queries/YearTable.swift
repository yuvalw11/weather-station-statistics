//
//  YearTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 28/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class YearTable: DBQuery, TableProtocol {
    
    override var dateColumn: Expression<Date> {
        return Expression<Date>("Date").fullYear
    }
    
    override var expressionsMapper: Dictionary<String, Expression<Double?>> {
        return [
            "AvgOutTempMax": Expression<Double?>("AvgOutTempMax").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "AvgOutTempMin": Expression<Double?>("AvgOutTempMin").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "AvgOutHumMax": Expression<Double?>("AvgOutHumMax").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "AvgOutHumMin": Expression<Double?>("AvgOutHumMin").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "OutTempMax": Expression<Double?>("OutTempMax").max,
            "OutTempMin": Expression<Double?>("OutTempMin").min,
            "OutHumMax": Expression<Double?>("OutHumMax").max,
            "OutHumMin": Expression<Double?>("OutHumMin").min,
            "TempDiffMax": Expression<Double?>("TempDiffMax").max,
            "AbsMax": Expression<Double?>("AbsMax").max,
            "AbsMin": Expression<Double?>("AbsMin").min,
            "RelMax": Expression<Double?>("RelMax").max,
            "RelMin": Expression<Double?>("RelMin").min,
            "RelAvg": Expression<Double?>("RelAvg").average,
            "WindSpeedAvg": Expression<Double?>("WindSpeedAvg").average,
            "GustSpeedMax": Expression<Double?>("GustSpeedMax").max,
            "WindDirectionAvg": Expression<Double?>("WindDirectionAvg").average,
            "WindChillMin": Expression<Double?>("WindChillMin").min,
            "DewPointMin": Expression<Double?>("DewPointMin").min,
            "DewPointMax": Expression<Double?>("DewPointMax").max,
            "HeatIndexMax": Expression<Double?>("HeatIndexMax").max,
            "RainRateMax": Expression<Double?>("RainRateMax").max,
            "MonthlyRain": Expression<Double?>("MonthlyRain").max,
            "NumberOfRainyDays": Expression<Double?>("NumberOfRainyDays").sum,
            "NumberOfHotDays": Expression<Double?>("NumberOfHotDays").sum,
            "RadiationMax": Expression<Double?>("RadiationMax").max,
            "UVIMax": Expression<Double?>("UVIMax").max,
            "Measurements": Expression<Double?>("Measurements").sum
        ]
    }
    
}

