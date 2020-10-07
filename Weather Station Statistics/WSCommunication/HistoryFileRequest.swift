//
//  HistoryFileRequest.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 14/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class HistoryFileRequest: RequestProtocol {
    
    static var identifier: String = "HISTORY_FILE"
        
    var bytes: Data {
        return Data()
    }
}
