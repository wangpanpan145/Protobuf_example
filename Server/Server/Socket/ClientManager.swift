//
//  ClientManager.swift
//  Server
//
//  Created by mac on 2021/2/4.
//

import UIKit

class ClientManager: NSObject {
    var tcpClient: TCPClient
    init(tcpClient: TCPClient) {
        self.tcpClient = tcpClient
        super.init()
    }
}

extension ClientManager {
    func startReadMsg() {
        print("开始新客户端")
        DispatchQueue.global().async {
            while true {
                if let countBytes = self.tcpClient.read(4) {
                    /**
                     [228, 189, 160, 229, 165, 189]
                     6
                     
                     [9, 0, 0, 0, 2, 0, 228, 189, 160, 229, 165, 189, 229, 149, 138]
                     15
                     
                     [18, 0, 0, 0, 2, 0, 228, 189, 160, 229, 165, 189, 229, 149, 138, 229, 149, 138, 229, 149, 138, 229, 149, 138]
                     24
                     read 读出来是数组
                     
                     首先读取的时候 长度是6 则是正常的 但是20的话则不正常 不是客户端传入的值 而且值有时候还不一样
                     */
                    
                    let countData:Data = Data(bytes: countBytes, count: 4)
                    var count = 0
                    (countData as NSData).getBytes(&count, length: 4)
                    print(count,countBytes,countData)
                    
                    guard let typeBytes = self.tcpClient.read(2) else { return  }
                    let typeData = Data(bytes: typeBytes, count: 2)
                    var type = 0
                    (typeData as NSData).getBytes(&type, length: 2)
                    print(type,typeBytes,typeData)
                    
                    guard let contentBytes = self.tcpClient.read(count) else { return  }
                    let contentData = Data(bytes: contentBytes, count: count)
                    
                    //buffer
                    let decodedInfo = try! UserInfo(serializedData: contentData)
                    print("buffer")
                    print(decodedInfo,decodedInfo.name)
                    
                    //字符串
                    let content0 = String(data: contentData, encoding: .utf8)
                    print(content0 ?? "空字符串",contentBytes,contentData)
                    //字典
                    let content = String(data: contentData, encoding: .utf8)
                    print(content ?? "空字符串",contentBytes,contentData)
                    
                    if true {
                        let content = try? JSONSerialization.jsonObject(with: contentData, options: .mutableContainers)
                        guard let json = content else { return  }
                        print(json)
                        let dic = json as! Dictionary<String,Any>
                        print(dic)
                        for i in dic {
                            print(i.key,i.value)
                        }
                    }
                    
                    
                
                    
                    
                }
            }
        }
    }
}
