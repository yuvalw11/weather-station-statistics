//
//  AppDelegate.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 16/12/2018.
//  Copyright © 2018 Yuval Weinstein. All rights reserved.
//

import Cocoa
import Charts
import SQLite


@available(OSX 10.15, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var calendar = Calendar.current
    
    func applicationWillFinishLaunching(_ notification: Notification) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "M/yyyy"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//
//        let wsConnector = WsConnector()
//        wsConnector.connect()
//        do {
//            AppDelegate.db = try WeatherDatabase(wsConnector: wsConnector)
//            let records = AppDelegate.db?.months.getRecords()
////            print(records![0].getDate())
////            print(records![0].getValue(att: "OutTempMax"))
//
//        } catch {
//            print("error")
//        }
        
//        let task = Process()
//        task.executableURL = URL(fileURLWithPath: "/Library/Frameworks/Python.framework/Versions/3.7/bin/python3")
//        task.arguments = ["/Users/yuvalw11/PycharmProjects/general_code/connect_to_ws.py"]
//        do {
//            try task.run()
//            task.waitUntilExit()
//        } catch {
//        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        let wsConnector = WsConnector()
//        wsConnector.assignObserver(historyFileObserver: self)
//        wsConnector.assignObserver(historyDataObserver: self)
//        wsConnector.connect()
//        wsConnector.getFiles()
//        wsConnector.getdata(year: 2020, fromRecordNumber: 1, numberOfRecords: 100)
        
//        let context = self.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherRecords")
////        request.predicate = NSPredicate(format: "inTemp = %@", 22.4)
//        let property = NSExpressionDescription()
//        property.name = "sum"
//        property.expression = NSExpression(forAggregate: [NSExpression(forVariable: "inTemp")])
//        property.expressionResultType = .doubleAttributeType
//        request.propertiesToGroupBy = [property]
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//               print(data.value(forKey: "inHum") as! Int)
//          }
//
//        } catch {
//
//            print("Failed")
//        }
        self.calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            })
            return container
        }()
        

}


