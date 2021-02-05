//
//  HYSocket.swift
//  Client
//
//  Created by mac on 2021/2/4.
//

import UIKit

class HYSocket: NSObject {
    var addr: String
    var port: Int
    var tcpClient: TCPClient
    
    init(addr: String = "0.0.0.0",port: Int = 7878) {
        self.addr = addr
        self.port = port
        tcpClient = TCPClient(addr: addr, port: port)
        super.init()
    }
    func connectServer() {
        let tuple = tcpClient.connect(timeout: 5)
        print(tuple)
    }
    func closeServer() {
        let tuple = tcpClient.close()
        print(tuple)
    }
    func sendMsg(str: String) {
        let tuple = tcpClient.send(str: str)
        print(tuple)
    }
    func sendMsg(data: Data) {
        let tuple = tcpClient.send(data: data)
        print(tuple)
    }
}
