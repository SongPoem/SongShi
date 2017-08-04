//
//  gamemViewController.swift
//  诵诗
//
//  Created by yuannnn on 2017/7/30.
//  Copyright © 2017年 mac. All rights reserved.
//

import Foundation

import UIKit

class gamemViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var statusLabel: UITextView!
    //数据库
    static var db: OpaquePointer? = nil
    
    //sqlite3_stmt指针
    static var stmt:OpaquePointer? = nil
    
    //填入诗句
    var fillIn: String?
    let inputText = UITextField()
    var addition = 0
    
    //参考位置
    var locate: CGFloat = 0.0
    
    //诗句摆放位置
    static let width = UIScreen.main.bounds.width
    let positionX = [[(width/2) + 30, (width/2) - 15], [(width/2) + 50, width/2, (width/2) - 50], [(width/2) + 90, (width/2) + 30, (width/2) - 30, (width/2) - 90]]
    
    //诗歌label
    var poemlabel = UILabel()
    
    //填空诗句符号
    let blankFrame = "︻\r\r\r\r\r\r\r︼"
    
    //检验按钮
    let checkButton = UIButton()
    
    //是否可以进入下一题
    var nexton = false
    
    var signOfSuccessDidAppear = false
    
    let gameTitleArr:[String] = ["花","月","春","风","夜","人","山","云","酒"]
    
    var timer:Timer!
    var sec:Int = 0
    
    @IBOutlet weak var gameTitle: UITextView!
    @IBOutlet weak var img1: UIImageView!//右边
    @IBOutlet weak var img2: UIImageView!//左边
    @IBOutlet weak var topPlayerLabel: UILabel!
    @IBOutlet weak var bottomPlayerLabel: UILabel!
    @IBOutlet weak var status2Label: UILabel!//youbian
    @IBOutlet weak var status1Label: UILabel!//ZUOBIAN
    @IBOutlet weak var head1: CircleProgressView!
    @IBOutlet weak var head2: CircleProgressView!
    
    let nf = NumberFormatter()
    
    var game: Game!
    var gameState = GameState()
    var actions: [Action] = []
//    var player_head:Int = 1
    
    //产生随机题号
    func blankID1(lineLimit: Int) -> Int{
        let id = arc4random_uniform(UInt32(gameTitleArr.count))
        
        return Int(id) >= lineLimit ? (lineLimit - 1) : Int(id)
    }

    var currentPlayerIsActive: Bool {
        guard let index = self.gameState.currentPlayerIndex else { return false }
        return self.game.localPlayerIdentifier == self.game.players[index].identifier
    }
    
    var currentPlayerIndex: Int {
        for (index, player) in self.game.players.enumerated() {
            if player.identifier == self.game.localPlayerIdentifier {
                return index
            }
        }
        assert(false, "This should never be triggered")
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleGameEvent),
                                               name: GameNotificationName,
                                               object: nil)
        timer = Timer.scheduledTimer(timeInterval: 1,target:self,selector:#selector(gamemViewController.changeplayer),userInfo:nil,repeats:true)
        
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        head1.isHidden=true;
        head2.isHidden=true;
        
        self.head1.clockwise = true
        self.head1.progress = Double(100)
        self.head2.clockwise = true
        self.head2.progress = Double(100)
        
        initInputText()
        initLabel()
        
        initTitle()
    }
    
    func initTitle() {
        let gameCurr = blankID1(lineLimit: gameTitleArr.count)
        gameTitle.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 50)
        gameTitle.translatesAutoresizingMaskIntoConstraints = false
        gameTitle.textAlignment = .center
        gameTitle.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1)
        gameTitle.text = gameTitleArr[gameCurr]
    }
    
    func initLabel() {
        //step
        operateQuery()
        if (sqlite3_step(singleViewController.stmt) == SQLITE_ROW) {
            
//            //诗句数组
//            var lines = [String]()
//            
//            //从数据库中读出的诗句
//            var sentence: String
//            
//            for i in 3...6{
//                //读
//                if let temp = UnsafePointer(sqlite3_column_text(singleViewController.stmt, Int32(i))){
//                    sentence = String.init(cString: temp)
//                    if sentence.characters.count >= 2{
//                        lines.append(sentence)
//                    } else{
//                        break
//                    }
//                }
//            }
            //输入框
            let line = UILabel()
            line.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 28)
            line.numberOfLines = 0
            line.translatesAutoresizingMaskIntoConstraints = false
            poemlabel = line
            line.textAlignment = .center
            line.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1)
            self.view.addSubview(line)
            line.text = blankFrame
            
            //                blank = i
            line.isUserInteractionEnabled = true
            
            //点击空label弹出键盘
            let tapGr = UITapGestureRecognizer(target: self, action: #selector(keyboardAppear(tap:)))
            line.addGestureRecognizer(tapGr)
            
            //加入输入框
            self.view.addSubview(inputText)
            addConstraints(line: inputText)
            
            //加入检验按钮
            initCheckButton()
            
            addConstraints(line: line)
        }
        
    }
    
    //点击屏幕收起键盘
    func keyboardDisappear(tap: UITapGestureRecognizer){
        if nexton {
            return
        }
        
        
        
        inputText.resignFirstResponder()
        inputText.isHidden = true
        if(inputText.text == String()){
            poemlabel.text = blankFrame
        } else{
            poemlabel.text = inputText.text
        }
    }
    
    func initInputText(){
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 28)
        inputText.textAlignment = .center
        inputText.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 0)
        inputText.delegate = self as UITextFieldDelegate
        inputText.returnKeyType = UIReturnKeyType.done
        inputText.isHidden = true
        inputText.tintColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 0)
        //监听输入变化
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: .UITextFieldTextDidChange, object: inputText)
    }
    
    @objc private func textFieldDidChange(notification: NSNotification){
        let textField = notification.object as! UITextField
        
        if textField.text != blankFrame{
            
            poemlabel.text = textField.text
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        fillIn = textField.text
        if(fillIn == String()){
            poemlabel.text = blankFrame
            checkButton.isUserInteractionEnabled = false
        } else{
            poemlabel.text = fillIn
            checkButton.setBackgroundImage(UIImage(named: "检验.png"), for: UIControlState.normal)
            checkButton.isUserInteractionEnabled = true
        }
        textField.isHidden = true
        return true
    }
    
    //点击label弹出键盘
    func keyboardAppear(tap: UITapGestureRecognizer){
        inputText.isHidden = false
        poemlabel.text = String()
        inputText.becomeFirstResponder()
        checkButton.setBackgroundImage(UIImage(named: "检验.png"), for: UIControlState.normal)
    }
    
    static func openDB(){
        //打开数据库
        let path = Bundle.main.path(forResource: "poemsentence", ofType: "db")
        let error = sqlite3_open_v2(path?.cString(using: .utf8), &singleViewController.db, SQLITE_OPEN_READONLY, nil)
        
        //数据库打开失败
        if  error != SQLITE_OK {
            print("数据库打开失败")
            sqlite3_close(singleViewController.db)
            print(path!)
        }
        
    }
    
    func operateQuery(){
        
        var level = UserDefaults.standard.integer(forKey: "level") == 0 ? 1 : UserDefaults.standard.integer(forKey: "level")
        if((level/10+1) != UserDefaults.standard.integer(forKey: "currentLevel")){
            level = (UserDefaults.standard.integer(forKey: "currentLevel")-1)*10+1+addition
//            levelNum = level
        }
        
        
        //查询语句
        let sql = "SELECT * FROM s_poem WHERE ID = \(level);"
        
        //编译
        if sqlite3_prepare_v2(singleViewController.db, sql.cString(using: .utf8), -1, &singleViewController.stmt, nil) != SQLITE_OK {
            sqlite3_finalize(singleViewController.stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
                print(String.init(cString: sqlite3_errmsg(singleViewController.db)))
            }
            sqlite3_close(singleViewController.db)
        }
        //        print(Int(sqlite3_column_int(singleViewController.stmt, 7)))
    }
    
    func initCheckButton(){
        self.view.addSubview(checkButton)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        checkButton.superview!.addConstraint(NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: poemlabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 4))
        
        checkButton.superview!.addConstraint(NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: poemlabel, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: -1 ))
        
        checkButton.addConstraint(NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 48))
        
        checkButton.addConstraint(NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 48))
        
        checkButton.setBackgroundImage(UIImage(named: "检验.png"), for: UIControlState.normal)
        
        checkButton.addTarget(self, action: #selector(checkIfRight), for: .touchUpInside)
        
        checkButton.isUserInteractionEnabled = true
        
    }
    
    //比较填入诗句是否正确
    func checkIfRight(){
        
        fillIn = inputText.text
        //        fillIn = "心悦君兮君不知"
        //        && poemlabel[blankNum].text != blankFrame
        var blank: String?//从数据库里面读
//        if fillIn == blank  {
        if fillIn == "gg"  {//回答对了以后首先要把时间清空成0
            sec = 0
            checkButton.setBackgroundImage(UIImage(named: "正确.png"), for: UIControlState.normal)
//            poemlabel.text = blank
            poemlabel.text = "zhengquela"
            self.gameState.playerScore[currentPlayerIndex] += 1
            status1Label.text = String(gameState.playerScore[0])
            status2Label.text = String(gameState.playerScore[1])
            switchToNextPoem()
            updateView()
            return
            
            
        } else{
            checkButton.setBackgroundImage(UIImage(named: "错误.png"), for: UIControlState.normal)
//            switchToNextPoem()//回答错误也要进入下一个人
            return
        }
        
        
        
    }

    //切换到下一玩家或者完成
    func switchToNextPoem(){//需要记录填写正确的诗句，下一次不能填写相同的诗句
        //还需要有判断，时间以内可以交无数次，时间到了只能提交
            runAction()//完成了tocomplete 在函数里面如果有人得到十分才结束
            inputText.text = String()
            inputText.removeFromSuperview()
            checkButton.removeFromSuperview()
            poemlabel.removeFromSuperview()
            
            initLabel()
            initable()
    }

    func initable(){
        inputText.isUserInteractionEnabled = true
        inputText.isEnabled = true
        poemlabel.isUserInteractionEnabled = true
        checkButton.isUserInteractionEnabled = true
        checkButton.isEnabled = true
        poemlabel.isEnabled = true
    }


    func addConstraints(line: UIView){
        
        let positionX = self.positionX[0][1]
        locate = positionX
        //添加约束
        
        line.superview!.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 170))
        
        line.superview!.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: CGFloat(positionX) ))
        
        line.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 400))
        
        line.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 35))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.game.start()
    }
    func handleGameEvent(_ notification: Notification) {
        if let action = notification.object as? Action {
            self.actions.append(action)
            self.gameState = action.applyTo(gameState: gameState)
        }
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //分别放本地的头像
//        img1player0
//        img2
        self.bottomPlayerLabel.text = self.game.players[0].displayName
        self.topPlayerLabel.text = self.game.players[1].displayName
        self.updateView()
    }
    
    //当判断正确的时候触发
    @IBAction func runAction() {
//        guard currentPlayerIsActive else { return }
//        let gameSelection = 1
        self.game.add(action: ChoiceAction(timeInterval: Date().timeIntervalSince1970))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeplayer() {
        var jud: Bool = currentPlayerIsActive
        //如果本地玩家是玩家0的话 那么根据本地玩家的情况控制右边的头像
        if self.game.players[currentPlayerIndex].identifier == self.game.players[0].identifier{
            jud = !currentPlayerIsActive
        }
        if jud {//左边的头像亮 应该是玩家1
            head1.isHidden=true;
            head2.isHidden=false;
            sec += 1
            self.head2.progress = Double(20-sec)/Double(20)
//            print(self.head2.progress)
            if sec == 20 {
//                player_head=2
                head1.isHidden=false;
                head2.isHidden=true;
                sec = 0
                switchToNextPoem()
            }
        }
        else {//玩家0
            head1.isHidden=false;
            head2.isHidden=true;
            sec += 1
            self.head1.progress = Double(20-sec)/Double(20)
            if sec == 20 {
//                player_head=1
                head1.isHidden=true;
                head2.isHidden=false;
                sec = 0
                switchToNextPoem()
            }
        }
        updateView()
    }
    
    func delay(_ delay:Double, closure: @escaping ()-> Void) {
        let delayTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: closure)
    }
    
    func updateView() {//更换图片在谁的头像上 以及最后的胜负 每十秒应该调用一次
//        status1Label.text = String(gameState.playerScore[0])
//        status1Label.text = String(gameState.playerScore[1])
        
        poemlabel.isEnabled = currentPlayerIsActive
        inputText.isEnabled = currentPlayerIsActive
        inputText.isUserInteractionEnabled = currentPlayerIsActive
        poemlabel.isUserInteractionEnabled = currentPlayerIsActive
        checkButton.isEnabled = currentPlayerIsActive
        switch self.gameState.status {
        case .awaitingPlay:
            self.statusLabel.text = currentPlayerIsActive ? "我方作答" : "对方作答"
        case .turnComplete:
            self.statusLabel.text = currentPlayerIsActive ? "我方作答" : "对方作答"
        case .finished(let results):
            guard let result = results[currentPlayerIndex] else { return }
            switch result {
            case .lost:
                self.statusLabel.text = "胜利"
            case .won:
                self.statusLabel.text = "失败"
            case .tie:
                self.statusLabel.text = "平局"
            }
        default:
            self.statusLabel.text = ""
        }

    }
    
    
    
}
