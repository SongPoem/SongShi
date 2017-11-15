//
//  LevelsViewController.swift
//  诵诗
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class LevelsViewController: UIViewController{
    
    @IBOutlet weak var springSwitcher: UIButton!
    @IBOutlet weak var summerSwitcher: UIButton!
    @IBOutlet weak var autumnSwitcher: UIButton!
    @IBOutlet weak var winterSwitcher: UIButton!
    
    
    @IBOutlet weak var sub: UIButton!
    @IBOutlet weak var first: UIButton!
    @IBOutlet weak var second: UIButton!
    @IBOutlet weak var third: UIButton!
    
    @IBOutlet weak var lock1: UIImageView!
    @IBOutlet weak var lock2: UIImageView!
    @IBOutlet weak var lock3: UIImageView!
    
    @IBOutlet weak var switching2: UIImageView!
    @IBOutlet weak var switching1: UIImageView!
    
    private var viewTag = viewTags(viewtag: 0, subviewtag: true)
    private var BGTag = true
    private var totalLevels = 0
    private var switcherArr:[UIButton] = []
    
    struct viewTags {
        var viewtag:Int
        var subviewtag:Bool
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        initButton(button: first, width: 96, height: 150, name:"1")
        initButton(button: second, width: 96, height: 150, name: "2")
        initButton(button: third, width: 96, height: 150, name: "3")
        initButton(button: sub, width: 80, height: 80, name: "一")
        
        enableButtons()
        
    }
    
    override func viewDidLoad() {
        //adjustments to button font
        bulidArr()
        enableButtons()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    @IBAction func switchToSingleView(_ sender: UIButton) {
        var i:Int = viewTag.viewtag * 6
        switch (sender, viewTag.subviewtag) {
        case (second, true):
            i += 2
        case (third, true):
            i += 3
        case (first, false):
            i += 4
        case (second, false):
            i += 5
        case (third, false):
            i += 6
        default:
            i += 1
        }
        
        UserDefaults.standard.set(i, forKey: "currentLevel")
        
        performSegue(withIdentifier: "mainToSingle", sender: sender)

    }
    
    
    //set levelButton
    func initButton(button:UIButton, width: CGFloat, height: CGFloat, name:String){
        
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: height))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: width))
        
        button.setImage(UIImage(named:name), for: .normal)
        
        
    }
    
    //after changing, lockOfButtons
    func enableButtons(){
        totalLevels = UserDefaults.standard.integer(forKey: "level")
        let i:Int = (totalLevels - (viewTag.viewtag+1)*10) / 60
        for a in 0...i {
            switcherArr[a].isUserInteractionEnabled = true
        }
        for a in i+1...3{
            switcherArr[a].isUserInteractionEnabled = false
        }
        
        //calculateLittleButtons
        let j = (Int)(totalLevels/10)
        
        let level2 = viewTag.viewtag*6
        if(totalLevels < 10 && viewTag.subviewtag){
            adjustLocked(a: 0, b: 1, c: 1)
        }else{
            if level2 + 6 < j {
                adjustLocked(a: 0, b: 0, c: 0)
            }else{
                let k = j % 6
                if viewTag.subviewtag {
                    switch k {
                    case 0:
                        adjustLocked(a: 0, b: 1, c: 1)
                    case 1:
                        adjustLocked(a: 0, b: 0, c: 1)
                    default:
                        adjustLocked(a: 0, b: 0, c: 0)
                    }
                }else{
                    switch k{
                    case 3:
                        adjustLocked(a: 0, b: 1, c: 1)
                    case 4:
                        adjustLocked(a: 0, b: 0, c: 1)
                    case 5:
                        adjustLocked(a: 0, b: 0, c: 0)
                    default:
                        adjustLocked(a: 1, b: 1, c: 1)
                    }
                }
            }
        }
    }
    
    
    //adjust to locked buttons
    func adjustLocked(a: CGFloat, b:CGFloat, c:CGFloat) {
        lock1.alpha = a
        lock2.alpha = b
        lock3.alpha = c
        
        first.isUserInteractionEnabled = translate(m: a)
        second.isUserInteractionEnabled = translate(m: b)
        third.isUserInteractionEnabled = translate(m: c)
    }
    
    func translate(m: CGFloat)->Bool{
        if m == 0 {
            return true
        }else{
            return false
        }
    }
    
    
    //场景切换按钮队列
    func bulidArr() {
        switcherArr.append(springSwitcher)
        switcherArr.append(summerSwitcher)
        switcherArr.append(autumnSwitcher)
        switcherArr.append(winterSwitcher)
    }
    
    //Switches of images
    func switchImages(a:String, b:String, c:String){
        first.setImage(UIImage(named:a), for: .normal)
        second.setImage(UIImage(named:b), for: .normal)
        third.setImage(UIImage(named:c), for: .normal)
    }
    
    func adjustBG(BG:UIImageView){
        self.view.addSubview(BG)
        self.view.sendSubview(toBack: BG)
        
        BG.superview!.addConstraint(NSLayoutConstraint(item: BG, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0))
        
        BG.superview!.addConstraint(NSLayoutConstraint(item: BG, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
        
        BG.superview!.addConstraint(NSLayoutConstraint(item: BG, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0 ))
        
        BG.superview!.addConstraint(NSLayoutConstraint(item: BG, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0 ))
    }
    
    func BGSwitch() {
        if BGTag {
            BGTag = false
            UIView.transition(from: switching1, to: switching2, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
            
            self.view.sendSubview(toBack: switching2)
            adjustBG(BG: switching1)
        }else{
            BGTag = true
            UIView.transition(from: switching2, to: switching1, duration: 0.8, options: .transitionCrossDissolve, completion: nil)
            self.view.sendSubview(toBack: switching1)
            adjustBG(BG: switching2)
        }
        
    }
    
    @IBAction func switchLevels(_ sender: UIButton){
        //切换
        BGSwitch()
        if sender.titleLabel != switcherArr[viewTag.viewtag].titleLabel {
            sender.setTitleColor(UIColor(red: 35/255, green: 98/255, blue: 118/255, alpha: 1), for: .normal)
            sender.titleLabel?.font = UIFont.init(name: "TypeLand KhangXi Dict Demo", size: 64)
            switcherArr[viewTag.viewtag].setTitleColor(UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1), for: .normal)
            switcherArr[viewTag.viewtag].titleLabel?.font = UIFont.init(name: "TypeLand KhangXi Dict Demo", size: 32)
        }
        
        for i in 0...3 {
            if sender == switcherArr[i] {
                viewTag.viewtag = i
                switchIcons()
            }
        }
    }
    
    //Switches between two subviews
    @IBAction func switchSubview(_ sender: UIButton){
        
        BGSwitch()
        if viewTag.subviewtag{
            viewTag.subviewtag = false
            sender.setImage(UIImage(named:"二"), for: .normal)
        }
        else{
            viewTag.subviewtag = true
            sender.setImage(UIImage(named:"一"), for: .normal)
        }
        switchIcons()
        
    }
    
    //switches of icons
    func switchIcons(){
        enableButtons()
        switch (viewTag.viewtag, viewTag.subviewtag){
        case (0, false):
            switchImages(a: "4", b: "5", c: "6")
        case (1, true):
            switchImages(a: "7", b: "8", c: "9")
        case (1, false):
            switchImages(a: "10", b: "11", c: "12")
        case (2, true):
            switchImages(a: "13", b: "14", c: "15")
        case (2, false):
            switchImages(a: "16", b: "17", c: "18")
        case (3, true):
            switchImages(a: "19", b: "20", c: "21")
        case (3, false):
            switchImages(a: "22", b: "23", c: "24")
        default:
            switchImages(a: "1", b: "2", c: "3")
        }
    }
    
    
}
