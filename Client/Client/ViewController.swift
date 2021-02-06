//
//  ViewController.swift
//  Client
//
//  Created by mac on 2021/2/3.
//

import UIKit

class ViewController: UIViewController {
    //UI
    var startButton: UIButton?
    var closeButton: UIButton?
    var statusLab: UILabel?
    //服务器
    //fileprivate lazy var socket: HYSocket = HYSocket(addr: "0.0.0.0", port: 9000)
    fileprivate lazy var socket: HYSocket = HYSocket()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}
 
extension ViewController {
    func setUI () {
        
        let titleLab: UILabel = UILabel(frame: CGRect(x: 100, y: 50, width: self.view.frame.size.width - 200, height: 40))
        self.view.addSubview(titleLab)
        titleLab.text = "客户端"
        titleLab.textAlignment = .center
        titleLab.backgroundColor = UIColor.purple
        titleLab.textColor = UIColor.white
        titleLab.layer.masksToBounds = true
        titleLab.layer.cornerRadius = 8
        
        
        
        let leftButton: UIButton = UIButton.init(type: .custom)
        self.view.addSubview(leftButton)
        leftButton.frame = CGRect(x: 10, y: 100, width: 100, height: 50)
        leftButton.setTitle("开启", for: .normal)
        leftButton.setTitleColor(UIColor.black, for: .normal)
        leftButton.setTitleColor(UIColor.green, for: .selected)
        leftButton.backgroundColor = UIColor.gray
        
        
        let rightButton: UIButton = UIButton.init(type: .custom)
        self.view.addSubview(rightButton)
        rightButton.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
        rightButton.setTitle("关闭", for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.setTitleColor(UIColor.green, for: .selected)
        rightButton.backgroundColor = UIColor.gray
        
        
        //添加点击事件
        leftButton.tag = 0
        rightButton.tag = 1
        leftButton.addTarget(self, action: #selector(clickItemButton(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(clickItemButton(_:)), for: .touchUpInside)
        
        self.startButton = leftButton
        self.closeButton = rightButton
        
        let statusLab = UILabel(frame: CGRect(x: 10, y: leftButton.frame.origin.y + leftButton.frame.size.height + 20, width: self.view.frame.size.width - 20, height: 30))
        self.view.addSubview(statusLab)
        self.statusLab = statusLab
    }
    
    @objc func clickItemButton (_ button: UIButton) {
        switch button.tag {
        case 0:
            if self.startButton!.isSelected {
                return
            }
            self.statusLab?.text = "连接状态：连接"
            self.startButton?.isSelected = true
            self.closeButton?.isSelected = false
            
            if socket.connectServer() {
                socket.startReadMsg()
            }
        case 1:
            if self.closeButton!.isSelected {
                return
            }
            self.statusLab?.text = "连接状态：断开"
            self.startButton?.isSelected = false
            self.closeButton?.isSelected = true
            
            socket.closeServer()
        default:
            print("lll")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //socket.sendJoinRoom()
        //socket.sendLeaveRoom()
        //socket.sendTextMsg(message: "nihao")
        socket.sendGifMessage(gifName: "火箭", gifUrl: "gif图", giftCount: 3)
    }
    
}









/**
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     //字符串
     //let content: String = "进入房间"
     //let contentData: Data = content.data(using: .utf8)!
     
     //字典
     //let content: [String:Any] = ["name":"wpp","age":"20"]
     //let contentData = (try?JSONSerialization.data(withJSONObject: content, options: []))!
     
     //buffer
     var info = UserInfo()
     info.name = "wpp"
     info.level = 2
     info.iconURL = "https://xxxxx.jpeg"
     let contentData:Data = try! info.serializedData()
     
     
     
     //1.获取消息长度 写入到data
     var count = contentData.count
     let countData = Data(bytes: &count, count: 4)
     print(count,countData)
     
     //2.消息类型
     var type = 1
     let typeData = Data(bytes: &type, count: 2)
     print(type,typeData)
     
     //3.消息汇总
     let totalData = countData + typeData + contentData
     print(totalData)
     
     socket.sendMsg(data: totalData)
     //socket.sendMsg(str: content)
 }
 */
