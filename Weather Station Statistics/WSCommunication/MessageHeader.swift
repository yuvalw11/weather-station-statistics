
//
//  MessageHeader.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 04/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

internal class MessageHeader {
    
    static let HeaderSize = 40
    
    var title: String
    var mode: String
    var identifier: String
    var size: Int
    
    init(data: Data) {
        let titleRaw = String(data: data.subdata(in: 0..<8), encoding: String.Encoding.ascii)!
        let typeRaw = String(data: data.subdata(in: 8..<16), encoding: String.Encoding.ascii)!
        let commandRaw = String(data: data.subdata(in: 16..<32), encoding: String.Encoding.ascii)!
        
        self.title = titleRaw.replacingOccurrences(of: "\0", with: "")
        self.mode = typeRaw.replacingOccurrences(of: "\0", with: "")
        self.identifier = commandRaw.replacingOccurrences(of: "\0", with: "")
        
        self.size = Int(littleEndian: data.subdata(in: 32..<36).withUnsafeBytes{$0.pointee}) - MessageHeader.HeaderSize
    }
    
    init(title: String, mode: String, identifier: String, size: Int) {
        self.title = title
        self.mode = mode
        self.identifier = identifier
        self.size = size + MessageHeader.HeaderSize
    }
    
    var bytes: Data {
        var data = Data()
        let title = self.title.padding(toLength: 8, withPad: "\0", startingAt: 0)
        let mode = self.mode.padding(toLength: 8, withPad: "\0", startingAt: 0)
        let identifier = self.identifier.padding(toLength: 16, withPad: "\0", startingAt: 0)
        let size = withUnsafeBytes(of: self.size) { Data($0) }
        
        data.append(contentsOf: title.data(using: .ascii)!)
        data.append(contentsOf: mode.data(using: .ascii)!)
        data.append(contentsOf: identifier.data(using: .ascii)!)
        data.append(size)
        
        return data
    }
}
