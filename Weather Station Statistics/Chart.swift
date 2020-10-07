//
//  Chart.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 13/02/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class Chart: NSImage {
    override func draw(in rect: NSRect) {
        let backgroundColor = NSBezierPath()
        backgroundColor.move(to: NSMakePoint(0, rect.height/2))
        backgroundColor.line(to: NSMakePoint(rect.width, rect.height/2))
        let strokeColor = NSColor.white
        strokeColor.setStroke()
        backgroundColor.lineWidth = rect.height
        backgroundColor.stroke()
    }
}
