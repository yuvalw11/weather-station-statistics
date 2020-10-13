//
//  DayTable.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 24/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

class DayTable: DBQuery, TableProtocol {
    
    override var expressionsMapper: Dictionary<String, Expression<Double?>> {
        
        return [
            "OutTempMax": Expression<Double?>("OutTemp").max,
            "OutTempMin": Expression<Double?>("OutTemp").min,
            "OutHumMax": Expression<Double?>("OutHum").max,
            "OutHumMin": Expression<Double?>("OutHum").min,
            "AbsMax": Expression<Double?>("Abs").max,
            "AbsMin": Expression<Double?>("Abs").min,
            "RelMax": Expression<Double?>("Rel").max,
            "RelMin": Expression<Double?>("Rel").min,
            "AbsAvg": Expression<Double?>("Abs").average,
            "RelAvg": Expression<Double?>("Rel").average,
            "WindSpeedAvg": Expression<Double?>("WindSpeed").average,
            "GustSpeedMax": Expression<Double?>("GustSpeed").max,
            "WindDirectionAvg": Expression<Double?>("WindDirection").average,
            "WindChillMin": Expression<Double?>("WindChill").min,
            "DewPointMin": Expression<Double?>("DewPoint").min,
            "DewPointMax": Expression<Double?>("DewPoint").max,
            "HeatIndexMax": Expression<Double?>("HeatIndex").max,
            "WasHot": cast(Expression<Double?>("HeatIndex").min < Expression<Double>(literal: "25.5")),
            "RainRateMax": Expression<Double?>("RainRate").max,
            "DailyRain": Expression<Double?>("DailyRain").max,
            "WasRain": cast(Expression<Double?>("DailyRain").max > Expression<Double>(literal: "0.0")),
            "RadiationMax": Expression<Double?>("Radiation").max,
            "UVIMax": Expression<Double?>("UVI").max,
            "Measurements": cast(Expression<Int?>("Id").count) 
        ]
    }
    
    override var dateColumn: Expression<Date> {
        return Expression<Date>("Date").fullDay
    }
}

