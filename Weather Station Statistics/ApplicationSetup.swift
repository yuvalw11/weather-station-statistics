//
//  ApplicationSetup.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class ApplicationSetup {
    
    static var AttMapper: Dictionary<ParameterType, Int> = [.Time : 1, .Temperature : 4, .Humidity : 5, .Wind : 6, .Gust: 7, .Dew : 8, .Chill : 9, .Direction : 10, .ABS : 11, .REL : 12, .RainRate : 13, .DailyRain : 14, .Rad : 18, .HeatIndex : 19, .UVI : 21]
    
    static var jsonAttMapper: Dictionary<ParameterType, String> = [.Time : "dateutc", .Temperature : "tempf", .Humidity : "humidity", .Wind : "windspeedmph", .Gust: "windgustmph", .Dew : "dewPoint", .Direction : "winddir", .ABS : "baromabsin", .REL : "baromrelin", .DailyRain : "dailyrainin", .Rad : "solarradiation", .UVI: "uv"]
    
    static var FileToRecords: FileToRecordsProtocol = CSVToRecords(attMapper: AttMapper)
    
    static var wsIP: String = ""
    
    static var pathToDB = "/Users/yuvalw11/Library/Containers/Yuval-Weinstein.Weather-Station-Statistics/Data/Documents/db.sqlite3"
    
    static var pathToContainer = "/Users/yuvalw11/Library/Containers/Yuval-Weinstein.Weather-Station-Statistics/Data/Documents"
    
    static var rainSeasonStartMonth = 8
    
    func loadDataTypeMapper() {
        
    }
}
