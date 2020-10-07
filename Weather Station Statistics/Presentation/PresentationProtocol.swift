//
//  PresentationProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol PresentationProtocol {
    func getTitle() -> String
    func getLeftText() -> String
    func getCenterText() -> String
    func getGraphHandlingProtocol() -> GraphHandlingProtocol?
    func registerObserver(observerToAdd: PresentationObserver)
    func removeObserver(observerToRemove: PresentationObserver)
}

protocol StaticPresentationProtocol: PresentationProtocol {
    
}

protocol PresentationObserver {
    func presentationChanged()
}

extension StaticPresentationProtocol {
    func registerObserver(observerToAdd: PresentationObserver) {}
    func removeObserver(observerToRemove: PresentationObserver) {}
}
