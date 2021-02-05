//
//  ViewController.swift
//  Server
//
//  Created by mac on 2021/2/3.
//

import UIKit

class ViewController: UIViewController {
    var startButton: UIButton?
    var closeButton: UIButton?
    var statusLab: UILabel?
    fileprivate lazy var serverMgr: ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
}

extension ViewController {
    func setUI () {
        
        let titleLab: UILabel = UILabel(frame: CGRect(x: 100, y: 50, width: self.view.frame.size.width - 200, height: 40))
        self.view.addSubview(titleLab)
        titleLab.text = "服务器"
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
            self.statusLab?.text = "服务器状态：开启"
            self.startButton?.isSelected = true
            self.closeButton?.isSelected = false
            
            serverMgr.startRunning()
        case 1:
            if self.closeButton!.isSelected {
                return
            }
            self.statusLab?.text = "服务器状态：关闭"
            self.startButton?.isSelected = false
            self.closeButton?.isSelected = true
            
            serverMgr.stopRunning()
        default:
            print("lll")
        }
    }
}

