//
//  HistoryFileResponseObserver.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 14/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol ConnectionObserver {
    func handleLookingForConnection()
    func handleFoundConnection()
    func handleNotFoundConnection()
    func handleConnectionStopped()
}

extension ConnectionObserver {
    func handleLookingForConnection() {}
    func handleFoundConnection() {}
    func handleNotFoundConnection() {}
    func handleConnectionStopped() {}
}
