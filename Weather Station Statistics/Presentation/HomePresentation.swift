//
//  HomePresentation.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 12/07/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class HomePresentation: PresentationProtocol, ConnectionObserver, DBObserver {
    
    private var observers: Array<PresentationObserver>
    private var record: WeatherRecord?
    private var wsConnector: WsConnector
    private var db: WeatherDatabase
    private var recordsRequestQueue: DispatchQueue
        
    init(wsConnector: WsConnector, db: WeatherDatabase) {
        self.observers = Array()
        self.record = nil
        self.recordsRequestQueue = DispatchQueue(label: "recordsRequestQueue")
        self.wsConnector = wsConnector
        self.db = db

        self.wsConnector.assignConnectionObserver(observer: self)
        self.db.assignObserver(observer: self)
        
        if wsConnector.isConnected {
            self.monitorWSForCurrentConditions()
        }
    }
    
    func getTitle() -> String {
        return "Home Screen"
    }
    
    func getLeftText() -> String {
        guard self.record != nil, let currentRecord = self.record else {
            return ""
        }
        
        let lines = [
            String(format: "Indoor Temperature: %.1f˚", currentRecord.values[.inTemp]!!),
            String(format: "Indoor Humidity: %d%%", Int(currentRecord.values[.inHumidity]!!)),
            String(format: "Outdoor Temperature: %.1f˚", currentRecord.values[.outTemp]!!),
            String(format: "Outdoor Humidity: %d%%", Int(currentRecord.values[.outHumidity]!!)),
            String(format: "Outdoor Dew Point: %.1f˚", currentRecord.values[.dew]!!),
            "",
            String(format: "Absolute Pressure: %.1f", currentRecord.values[.abs]!!),
            String(format: "Relative Pressure: %.1f", currentRecord.values[.rel]!!),
            "",
            String(format: "Wind speed: %.1f", currentRecord.values[.wind]!!),
            String(format: "Gust speed: %.1f", currentRecord.values[.gust]!!),
            String(format: "Wind direction: %@", self.windDirection),
            "",
            String(format: "Radiation: %.1f", currentRecord.values[.radiation]!!),
            String(format: "UV: %d", Int(currentRecord.values[.uvi]!!)),
            String(format: "Daily Rain: %.1f", currentRecord.values[.dailyRain]!!)
        ]
        
        return lines.joined(separator: "\n")
    }
    
    func getCenterText() -> String {
        guard let currentRecord = self.record, let dbDayStatement = self.db.dbDays[self.currentDate] else {
            return "Can't get weather data."
        }
                        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yy - HH:mm"
                
        let lines = [
            String(format: "Last update: %@", dateFormatter.string(from: currentRecord.time)),
            String(format: "Amount of measures: %d", Int(dbDayStatement.first!["Measurements"]!)),
            String(format: "Today's high: %.1f˚", (dbDayStatement.first!["OutTempMax"])!),
            String(format: "Today's low: %.1f˚", (dbDayStatement.first!["OutTempMin"])!)
        ]
        
        return lines.joined(separator: "\n")
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        guard self.record != nil, let dailyRecords = self.db.dbRecordsForDay[self.currentDate] else {
            return nil
        }
        
        return GraphHandler(handlerConfig: DayGraphHandlerConfiguration(recordsStatement: dailyRecords))
    }
    
    func monitorWSForCurrentConditions() {
        self.recordsRequestQueue.async {
            while self.wsConnector.isConnected {
                guard let response = self.wsConnector.requestNowRecord() else {
                    print("could not receive now record response")
                    return
                }
                
                self.record = response.nowRecord
                for observer in self.observers {
                    observer.presentationChanged()
                }

                sleep(5)
            }
        }
    }
    
    private var isReady: Bool {
        return self.record != nil && (self.db.dbRecordsForDay.contains{(key, value) in return key == self.currentDate})
    }
    
    private var currentDate: Date {
        var calendar = Calendar.current
        let dateComponents = calendar.dateComponents(Set(arrayLiteral: .day, .month, .year), from: Date(timeIntervalSinceNow: 0))
               
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.date(from: dateComponents)!
    }
        
    private var windDirection: String {
        guard let currentRecord = self.record else {
            return ""
        }
        
        let direction = currentRecord.values[.windDirection]!!
        
        if currentRecord.values[.wind] == 0 {
            return "-"
        }
        
        if direction >= 22.5 && direction < 67.5 {
            return "NE"
        } else if direction >= 67.5 && direction < 112.5 {
            return "E"
        } else if direction >= 112.5 && direction < 157.5 {
            return "SE"
        } else if direction >= 157.5 && direction < 202.5 {
            return "S"
        } else if direction >= 202.5 && direction < 247.5 {
            return "SW"
        } else if direction >= 247.5 && direction < 292.5 {
            return "W"
        }  else if direction >= 292.5 && direction < 337.5 {
            return "NW"
        } else {
            return "N"
        }
    }
    
    func handleFoundConnection() {
        self.monitorWSForCurrentConditions()
    }
    
    func registerObserver(observerToAdd: PresentationObserver) {
        self.observers.append(observerToAdd)
    }
    
    func removeObserver(observerToRemove: PresentationObserver) {
        self.observers.removeAll { (observer) -> Bool in
            return observer as AnyObject === observerToRemove as AnyObject
        }
    }
}
