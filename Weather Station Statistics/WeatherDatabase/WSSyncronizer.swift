//
//  WSSyncronizer.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 20/07/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite


/// This class repreents a syncornizer object that comunicates via the remote WS and notifies for any descrepancy of the database with the WS.
internal class WSSyncronizer {
    
    private let wsConnector: WsConnector
    private let db: WeatherDatabase
    private let monitoringQueue: DispatchQueue
    
    init(wsConnector: WsConnector, db: WeatherDatabase) {
        self.wsConnector = wsConnector
        self.db = db
        self.monitoringQueue = DispatchQueue(label: "monitoringQueue")
    }
                
    func monitorWS(monitorEvery: UInt32) {
        self.monitoringQueue.async {
            while self.wsConnector.isConnected {
                self.handleDescrepancy()
                sleep(monitorEvery)
            }
        }
    }
            
    private func handleDescrepancy() {
        guard let response = self.wsConnector.requestHistoryFiles() else {
            return handleDescrepancy()
        }
        
        guard let recordsForYearInDB = try? self.db.recordsForYear() else {
            return
        }
        
        for file in response.files {
            let annotatedFileRecordsLength = recordsForYearInDB[file] ?? 0
            let wsFileRecordsLength = response.getNumberOfRecordsForFile(file: file)!
            let missingRecordsLength = wsFileRecordsLength - annotatedFileRecordsLength
            if missingRecordsLength > 0 {
                let insertSession = self.db.createInsertSession(id: "wsSyncronizerSession")
                insertSession.start(total: missingRecordsLength)
                
                print("requesting for file: \(file): \(missingRecordsLength) records from record number \(annotatedFileRecordsLength)")
                let proccessFinished = self.wsConnector.requestHistoryData(year: file, fromRecordNumber: annotatedFileRecordsLength, numberOfRecords: missingRecordsLength) { (response) in
                    guard let response = response else {
                        print("could not update database by new records from the ws.")
                        print("requested: year:\(file), from record number: \(annotatedFileRecordsLength), length: \(missingRecordsLength)")
                        return
                    }
                    
                    insertSession.insert(records: response.records)
                }
                
                proccessFinished.wait()
            }
        }
        
    }
}
