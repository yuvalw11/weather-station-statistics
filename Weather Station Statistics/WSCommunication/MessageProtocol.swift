//
//  MessageProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 04/04/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import Network

protocol ResponseProtocol {
    static var identifier: String {get}
    init(data: Data)
}

protocol RequestProtocol {
    static var identifier: String {get}
    var bytes: Data {get}
}
