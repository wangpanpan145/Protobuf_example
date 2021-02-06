//
//  ServerManager.swift
//  Server
//
//  Created by mac on 2021/2/3.
//

import UIKit
protocol ListenDelegate : class {
    func listenStatus(startStatus: Bool,startContent: String)
}
class ServerManager: NSObject {
    weak var delete: ListenDelegate?
    fileprivate lazy var isServerRunning: Bool = false
    fileprivate lazy var tcpServer: TCPServer = TCPServer(addr: "0.0.0.0", port: 7878)
    fileprivate lazy var clientMrgs: [ClientManager] = [ClientManager]()
    func startRunning() {
        //接收监听状态
        let tuple = tcpServer.listen()
        //if let
        if let startStatus = Optional(tuple.0) {
            print("端口监听成功 \(startStatus)")
        } else {
            print("端口监听失败\(tuple.1)")
        }
        //guard
        guard tuple.0 else {
            return
        }
        //开始接受客户端 accept必须放在异步线程里面 不然会卡死的 而且需要不停监听是否有新的连接
        isServerRunning = true
        DispatchQueue.global().async {
            while self.isServerRunning {
                if let tcpClient = self.tcpServer.accept() {
                    self.handleClient(tcpClient: tcpClient)
                }
            }
        }
    }
    func stopRunning() {
        isServerRunning = false
        print(tcpServer.close())
    }
}


extension ServerManager {
    func handleClient(tcpClient: TCPClient) {
        let mgr: ClientManager = ClientManager(tcpClient: tcpClient)
        clientMrgs.append(mgr)
        mgr.startReadMsg()
        mgr.delete = self
    }
}

extension ServerManager : ClientManagerDelete {
    func sendMsgToClient(data: Data) {
        print("回调啦 ServerManager")
        for mgr in clientMrgs {
            print("主动回调。。。")
            mgr.tcpClient.send(data: data)
        }
    }
}
