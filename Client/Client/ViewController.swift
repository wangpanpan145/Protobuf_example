//
//  ViewController.swift
//  Client
//
//  Created by mac on 2021/2/3.
//
/**
 1.获取到服务区对应的IP、端口号
 2.使用Socket，通过IP、端口号和服务器建立连接
 3.开启定时器，实时让服务器发送心跳包
 4.通过sendMsg，给服务器发送消息：字节流 ---> heartData(消息的长度）+typeData（消息类型）+msgData（真正消息）
 5.读取服务器传送过来的消息（开启子线程）
 */

import UIKit

class ViewController: UIViewController {
    //UI
    var startButton: UIButton?
    var closeButton: UIButton?
    var statusLab: UILabel?
    //服务器
    //fileprivate lazy var socket: HYSocket = HYSocket(addr: "0.0.0.0", port: 9000)
    fileprivate lazy var socket: HYSocket = HYSocket()
    //定时器
    fileprivate var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    deinit {
        timer.invalidate()
        timer = nil
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
                timer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
                RunLoop.main.add(timer, forMode: .common)
            }
        case 1:
            if self.closeButton!.isSelected {
                return
            }
            self.statusLab?.text = "连接状态：断开"
            self.startButton?.isSelected = false
            self.closeButton?.isSelected = true
            
            socket.closeServer()
            
            timer.invalidate()
            timer = nil
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
extension ViewController {
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}

