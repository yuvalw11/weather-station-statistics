//
//  MonthTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 28/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class MonthTable: DBQuery, TableProtocol {    
    
    override var expressionsMapper: Dictionary<String, Expression<Double?>> {
        
        return [
            "AvgOutTempMax": Expression<Double?>("OutTempMax").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "AvgOutTempMin": Expression<Double?>("OutTempMin").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "AvgOutHumMax": Expression<Double?>("OutHumMax").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            "AvgOutHumMin": Expression<Double?>("OutHumMin").sum / (cast(Expression<Double?>("Id").count) as Expression<Double?>),
            
            "OutTempMax": Expression<Double?>("OutTempMax").max,
            "OutTempMin": Expression<Double?>("OutTempMin").min,
            "OutHumMax": Expression<Double?>("OutHumMax").max,
            "OutHumMin": Expression<Double?>("OutHumMin").min,
            
            "TempDiffMax": (Expression<Double?>("OutTempMax") - Expression<Double?>("OutTempMin")).max,
            
            "AbsMax": Expression<Double?>("AbsMax").max,
            "AbsMin": Expression<Double?>("AbsMin").min,
            "RelMax": Expression<Double?>("RelMax").max,
            "RelMin": Expression<Double?>("RelMin").min,
            "AbsAvg": Expression<Double?>("AbsAvg").average,
            "RelAvg": Expression<Double?>("RelAvg").average,
            
            "WindSpeedAvg": Expression<Double?>("WindSpeedAvg").average,
            "GustSpeedMax": Expression<Double?>("GustSpeedMax").max,
            "WindDirectionAvg": Expression<Double?>("WindDirectionAvg").average,
            "WindChillMin": Expression<Double?>("WindChillMin").min,
            "DewPointMin": Expression<Double?>("DewPointMin").min,
            "DewPointMax": Expression<Double?>("DewPointMax").max,
            "HeatIndexMax": Expression<Double?>("HeatIndexMax").max,
            "RainRateMax": Expression<Double?>("RainRateMax").max,
            "MonthlyRain": Expression<Double?>("DailyRain").sum,
            "NumberOfRainyDays": Expression<Double?>("WasRain").sum,
            "NumberOfHotDays": Expression<Double?>("WasHot").sum,
            
            "RadiationMax": Expression<Double?>("RadiationMax").max,
            "RadiationMaxAvg": Expression<Double?>("RadiationMax").average,
            
            "UVIMax": Expression<Double?>("UVIMax").max,
            "UVIMaxAvg": Expression<Double?>("UVIMax").average,
            
            "Measurements": Expression<Double?>("Measurements").sum
        ]
    }
    
    override var dateColumn: Expression<Date> {
        return Expression<Date>("Date").fullMonth
    }
}

