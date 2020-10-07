//
//  GraphHandlingProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol GraphHandlingProtocol {
    
    func getPeriodDomain() -> [String]
    func getDataDomainForPeriod(period: String) -> [String]
    func getGraph(period: String, Data: String, ymax: Double?, ymin: Double?) -> GraphProtocol?
}
