//
//  DBListener.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 04/04/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

protocol DBObserver {
    func recordsChanged()
    func recordInserted(total: Int)
    func recordInserted(session: InsertSession)
}

extension DBObserver {
    func recordsChanged() {}
    func recordInserted(total: Int) {}
    func recordInserted(session: InsertSession) {}
}
