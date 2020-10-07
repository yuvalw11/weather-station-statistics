//
//  JsonToRecords.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 22/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

//class JsonToRecords: FileToRecordsProtocol {
//
//    private var mapper: Dictionary<ParameterType, String>
//
//    init(mapper: Dictionary<ParameterType, String>) {
//        self.mapper = mapper
//    }
//
//    func fileToRecord(file: URL) -> Dictionary<Date, Record> {
//        var records: Dictionary<Date, Record> = [:]
//        do {
//            let data = try Data(base64Encoded: String(contentsOf: file))
//            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [Dictionary<String, Double>]
//            for line in json {
//
//            }
//        }
//        catch {/* error handling here */}
//
//        return records
//    }
//
//    func fileToRecord(file: URL) -> Dictionary<Date, Record> {
//        <#code#>
//    }
//
//
//}
