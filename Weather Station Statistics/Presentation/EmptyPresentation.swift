//
//  EmptyPresentation.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 02/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

class EmptyPresentaion: StaticPresentationProtocol {
    func getTitle() -> String {
        return ""
    }
    
    func getLeftText() -> String {
        return "no data avilable"
    }
    
    func getCenterText() -> String {
        return ""
    }
    
    func getGraphHandlingProtocol() -> GraphHandlingProtocol? {
        return nil
    }
    
    
    
}
