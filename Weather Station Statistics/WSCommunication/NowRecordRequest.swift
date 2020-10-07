//
//  NowRecordRequest.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 05/07/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class NowRecordRequest: RequestProtocol {
    
    static var identifier: String = "NOWRECORD"
    
    var bytes: Data {
        return Data()
    }
}
