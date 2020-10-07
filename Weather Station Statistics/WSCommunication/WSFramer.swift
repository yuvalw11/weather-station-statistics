//
//  WSFramer.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 31/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import Network


class WSFramer: NWProtocolFramerImplementation {
    
    static let definition = NWProtocolFramer.Definition(implementation: WSFramer.self)
    
    static var label: String {
        return "WSMessagesFramer"
    }
    
    required init(framer: NWProtocolFramer.Instance) {
        
    }
    
    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult {
        return .ready
    }
    
    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        while true {
            var tempHeader: MessageHeader?
            
            let headerParsed = framer.parseInput(minimumIncompleteLength: MessageHeader.HeaderSize, maximumLength: MessageHeader.HeaderSize) { (buffer, isComplete) -> Int in
                
                guard let buffer = buffer else {
                    return 0
                }
                
                if buffer.count < MessageHeader.HeaderSize {
                    return 0
                }
                
                let data = Data(bytes: buffer.baseAddress!, count: MessageHeader.HeaderSize)
                
                tempHeader = MessageHeader(data: data)
                return MessageHeader.HeaderSize
            }
            
            guard headerParsed, let header = tempHeader else {
                return MessageHeader.HeaderSize
            }
                        
            let message = NWProtocolFramer.Message(identifier: header.identifier)
            let delivered = framer.deliverInputNoCopy(length: header.size, message: message, isComplete: true)
            
            if !delivered {
                return 0
            }
        }
    }
    
    func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {
        let header = MessageHeader(title: "PC2000", mode: "READ", identifier: message.messageIdentifier!, size: messageLength)
        framer.writeOutput(data: header.bytes)
        do {
            if messageLength > 0 {
                try framer.writeOutputNoCopy(length: messageLength)
            }
        } catch let error {
            print("error writing message: \(error)")
        }
    }
    
    func wakeup(framer: NWProtocolFramer.Instance) {
        
    }
    
    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        return true
    }
    
    func cleanup(framer: NWProtocolFramer.Instance) {
        
    }
}

extension NWProtocolFramer.Message {
    
    convenience init(identifier: String) {
        self.init(definition: WSFramer.definition)
        self.messageIdentifier = identifier
    }
    
    var messageIdentifier: String? {
        get {
            return self["MessageIdentifier"] as? String
        }
        set {
            self["MessageIdentifier"] = newValue
        }
    }
}
