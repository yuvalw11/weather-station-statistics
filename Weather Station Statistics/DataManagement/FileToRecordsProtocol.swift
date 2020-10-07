//
//  FileToRecordsProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 20/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol FileToRecordsProtocol {
    func fileToRecord(file: URL) -> [Record]
}
