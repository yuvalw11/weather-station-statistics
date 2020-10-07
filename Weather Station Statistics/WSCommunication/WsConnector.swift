//
//  WsConnector.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 03/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import Network

/// This class should be used to connect to the remote weather station.
///
/// In order to start the connection connect function should be invoked with the ip of the weather station or a broadcast ip.
///
/// The communication is done through requests fron host and responses from the weather station.
/// Please refer to the API in order to send requests to the weather station.
/// In order to get the responses from the weather station a response observer should be registered.
/// All response observers are notified when a new response arrives from the weather station.
///
class WsConnector {
    
    private var wsConnection: NWConnection?
    private var wsConnectionQueue: DispatchQueue
    
    private var connectionAvailableSemaphore: DispatchSemaphore
    private var blockReceiveSemaphore: DispatchSemaphore
    private var readyToUseSemaphore: DispatchSemaphore
    
    private var connectionObservers: [ConnectionObserver]
        
    init() {
        self.wsConnectionQueue = DispatchQueue(label: "sendReceivesQueue", qos: .utility)
        
        self.readyToUseSemaphore = DispatchSemaphore(value: 0)
        self.connectionAvailableSemaphore = DispatchSemaphore(value: 0)
        self.blockReceiveSemaphore = DispatchSemaphore(value: 1)

        self.connectionObservers = Array<ConnectionObserver>()
    }
    
    /// Establishes a connection with the remote weather station.
    /// - Parameter ip: The ip of the weather station or a broadcast ip.
    func connect(ip: String, timeout: Int = 20) {
        self.wsConnectionQueue.async {
            self.connectionObservers.forEach {$0.handleLookingForConnection()}
            self.setTcpServer()
            let wsFound = self.search(ip: ip, timeout: timeout)
            
            if wsFound {
                self.readyToUseSemaphore.wait()
                self.connectionObservers.forEach {$0.handleFoundConnection()}
            } else {
                self.connectionObservers.forEach {$0.handleNotFoundConnection()}
            }
        }
    }
    
    /// Requests history annotations from the weather station.
    /// - Parameters:
    ///   - year: The year of the desired annotations.
    ///   - fromRecordNumber: The index of the first record to obtain.
    ///   - numberOfRecords: The number of records to obtain from the weather station.
    ///
    func requestHistoryData(year: Int, fromRecordNumber: Int, numberOfRecords: Int, completion: @escaping (_ response: HistoryDataResponse?) -> Void) -> DispatchSemaphore {
        let maxRecordNumber = 1000
        let finishedSemaphore = DispatchSemaphore(value: 0)
        self.wsConnectionQueue.async {
            for i in stride(from: fromRecordNumber, through: fromRecordNumber + numberOfRecords, by: maxRecordNumber) {
                let size = min(maxRecordNumber, fromRecordNumber + numberOfRecords - i)
                let request = HistoryDataRequest(year: year, fromRecordNumber: i, numberOfRecords: size)
                print("getting records \(i)-\(i+size)")
                guard let data = self.BlockingReceive(request: request, expectedIdentifier: HistoryDataRequest.identifier) else {
                    print("Could not get the response to History Data Request. Requested: year-\(year), fromRecordNumber-\(fromRecordNumber), numberOfRecords-\(numberOfRecords)")
                    completion(nil)
                    return
                }
                
                completion(HistoryDataResponse(data: data))
            }
            finishedSemaphore.signal()
        }
        
        return finishedSemaphore
    }
            
    /// Requests data regarding the history files available. Each file is identified by a certain year and it contains records from that year.
    func requestHistoryFiles(completion: @escaping (_ response: HistoryFileResponse?) -> Void) {
        self.wsConnectionQueue.async {
            completion(self.requestHistoryFiles())
        }
    }
    
    func requestHistoryFiles() -> HistoryFileResponse? {
        let request = HistoryFileRequest()
        guard let data = self.BlockingReceive(request: request, expectedIdentifier: HistoryFileRequest.identifier) else {
            return nil
        }
        
        return HistoryFileResponse(data: data)
    }
    
    private func BlockingReceive(request: RequestProtocol, expectedIdentifier: String) -> Data? {
        self.blockReceiveSemaphore.wait()
        let responseReceived = DispatchSemaphore(value: 0)
        var rawContent: Data? = nil
        let metadata = NWProtocolFramer.Message(identifier: type(of: request).identifier)
        let context = NWConnection.ContentContext(identifier: "Data", metadata: [metadata])
        self.wsConnection!.send(content: request.bytes, contentContext: context, isComplete: true, completion: .contentProcessed { (error) in})
        self.wsConnection!.receiveMessage { (content, context, isComplete, error) in

            let messageParams = context?.protocolMetadata(definition: WSFramer.definition) as? NWProtocolFramer.Message
            let identifier = messageParams?.messageIdentifier
            if identifier == expectedIdentifier {
                rawContent = content
            } else {
                print("BlockingReceive: Expected identifier: \(expectedIdentifier) but received \(identifier)")
                rawContent = nil
            }
            responseReceived.signal()
        }
        
        responseReceived.wait()
        self.blockReceiveSemaphore.signal()
        return rawContent
    }
    
    func requestNowRecord(completion: @escaping (_ response: NowRecordResponse?) -> Void) {
        self.wsConnectionQueue.async {
            completion(self.requestNowRecord())
        }
    }
    
    func requestNowRecord() -> NowRecordResponse? {
        let request = NowRecordRequest()
        guard let data = self.BlockingReceive(request: request, expectedIdentifier: NowRecordRequest.identifier) else {
            return nil
        }
        
        return NowRecordResponse(data: data)
    }

    private func search(ip: String, timeout: Int) -> Bool {
        let udpConnection = NWConnection(host: NWEndpoint.Host(ip), port: 6000, using: .udp)
        let udpConnectionQueue = DispatchQueue(label: "udpQueue", qos: .utility)
        udpConnection.start(queue: udpConnectionQueue)
        let searchMessage = MessageHeader(title: "PC2000", mode: "SEARCH", identifier: "", size: 0)
        
        for _ in 0..<timeout {
            udpConnection.send(content: searchMessage.bytes, contentContext: .defaultMessage, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({ (error) in }))
            
            let dispatchTimeoutResult = self.connectionAvailableSemaphore.wait(timeout: DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(1)))
            
            if dispatchTimeoutResult == .success {
                return true
            }
        }
        return false
    }

    private func sendRequest(request: RequestProtocol) {
        let metadata = NWProtocolFramer.Message(identifier: type(of: request).identifier)
        let context = NWConnection.ContentContext(identifier: "Data", metadata: [metadata])
        guard let wsConnection = self.wsConnection else {
            return
        }
        
        wsConnection.send(content: request.bytes, contentContext: context, isComplete: true, completion: .contentProcessed({ (error) in
        }))
    }
            
    private func setTcpServer() {
        do {
            let tcpOptions = NWProtocolTCP.Options()
            tcpOptions.enableKeepalive = true
            tcpOptions.keepaliveIdle = 2
            
            let wsOptions = NWProtocolFramer.Options(definition: WSFramer.definition)
            
            let parameters = NWParameters(tls: nil, tcp: tcpOptions)
            
            parameters.includePeerToPeer = true
            
            parameters.defaultProtocolStack.applicationProtocols.insert(wsOptions, at: 0)
            
            let listener = try NWListener(using: parameters, on: 6500)
            listener.newConnectionLimit = 1
            listener.newConnectionHandler = self.newConnection
            listener.start(queue: DispatchQueue(label: "tcpQueue"))
            
        } catch {
            print("could not connect")
        }
    }
    
    private func newConnection(connection: NWConnection) {
        if self.wsConnection == nil {
            self.wsConnection = connection
            self.connectionAvailableSemaphore.signal()
            self.wsConnection?.stateUpdateHandler = {
                (state) in
                if state == .ready {
                    self.readyToUseSemaphore.signal()
                } else if (state == .failed(NWError.posix(.ECONNRESET)) || (state == .cancelled)) {
                    self.wsConnection?.cancel()
                    self.connectionObservers.forEach {$0.handleConnectionStopped()}
                }
            }
            self.wsConnection?.start(queue: DispatchQueue(label: "connectionQueue"))
        }
    }
    
    var isConnected: Bool {
        guard let wsConnection = self.wsConnection else {
            return false
        }
        
        return wsConnection.state == .ready
    }
            
    func assignConnectionObserver(observer: ConnectionObserver) {
        self.connectionObservers.append(observer)
    }

    func removeConnectionObserver(observer: ConnectionObserver) {
        self.connectionObservers.removeAll { (iterObserver) -> Bool in
            return observer as AnyObject === iterObserver as AnyObject
        }

    }
}
