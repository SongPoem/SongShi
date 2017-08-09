//
//  ViewController.swift
//  SongTest
//
//  Created by Lin on 17/3/19.
//  Copyright © 2017年 macbookair. All rights reserved.
//

import UIKit
import Speech

class singleViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var backgroundPic: UIImageView!
    
    //初始化语音设置
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh_CN"))
    
    //数据库
    static var db: OpaquePointer? = nil
    
    //sqlite3_stmt指针
    static var stmt:OpaquePointer? = nil
    
    //填空诗句
    var blank: String?
    //填入诗句
    var fillIn: String?
    let inputText = UITextField()
    var addition = 0
    
    //用户答案
    var userpoem: String?
    //朗诵是否成功
    var Issuccess = false
    //是否可以进入下一题
    var nexton = false
    
    //保存当前诗名
    var dbname = ""
    //参考位置
    var locate: CGFloat = 0.0
    
    //空诗句的编号
    var blankNum = 0
    
    //诗句数量
    var sentenceCount = 0
    //第几句诗
    var sentenceNum = 0
    
    //诗句摆放位置
    static let width = UIScreen.main.bounds.width
    let positionX = [[(width/2) + 30, (width/2) - 30], [(width/2) + 50, width/2, (width/2) - 50], [(width/2) + 90, (width/2) + 30, (width/2) - 30, (width/2) - 90]]
    
    //诗歌label
    var poemlabel = [UILabel]()
    
    //填空诗句符号
    let blankFrame = "︻\r\r\r\r\r\r\r︼"
    
    //诵诗按钮
    let readButton = UIButton(type: UIButtonType.custom)
    
    //是否正在录音
    var ifClickRecord = true
    
    //用户关卡数
    var levelNum: Int = 1
    
    //检验按钮
    let checkButton = UIButton()
    
    var signOfSuccessDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //使用用户数据，设置教学*****
        
        initInputText()
        initBackground()
        initLabel()
        initSpeech()
        
        print(UserDefaults.standard.integer(forKey: "currentLevel"))
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBackground(){
        
        view.isUserInteractionEnabled = true
        
        let tapGr = UITapGestureRecognizer(target: self, action: #selector(keyboardDisappear(tap:)))
        view.addGestureRecognizer(tapGr)
        
        let slide = UISwipeGestureRecognizer(target: self, action: #selector(switchToNextPoem(slide:)))
        slide.direction = UISwipeGestureRecognizerDirection.left
        
        view.addGestureRecognizer(slide)
        
    }
    //初始化语音设置
    func initSpeech(){
        speechRecognizer?.delegate = self
        
    }
    
    func initLabel() {
        //step
        operateQuery()
        if (sqlite3_step(singleViewController.stmt) == SQLITE_ROW) {
            
            //诗句数组
            var lines = [String]()
            //诗句数量
            sentenceCount = Int(sqlite3_column_int(singleViewController.stmt, 7))
            
            //从数据库中读出的诗句
            var sentence: String
            
            //填空诗句题号
            blankNum = blankID(lineLimit: sentenceCount)
            
            if let xdbname = UnsafePointer(sqlite3_column_text(singleViewController.stmt, 1)){
                dbname = String.init(cString: xdbname)
                dbname = "|\n|︽"+dbname+"︾"
            }
            
            for i in 3...6{
                //读
                if let temp = UnsafePointer(sqlite3_column_text(singleViewController.stmt, Int32(i))){
                    sentence = String.init(cString: temp)
                    if sentence.characters.count >= 2{
                        lines.append(sentence)
                    } else{
                        break
                    }
                }
            }
            
            for i in lines{
                
                let line = UILabel()
                line.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 28)
                line.numberOfLines = 0
                line.translatesAutoresizingMaskIntoConstraints = false
                poemlabel.append(line)
                line.textAlignment = .center
                line.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1)
                self.view.addSubview(line)
                if i != lines[blankNum]{
                    line.text = i
                } else{
                    line.text = blankFrame
                    blank = i
                    line.isUserInteractionEnabled = true
                    
                    //点击空label弹出键盘
                    let tapGr = UITapGestureRecognizer(target: self, action: #selector(keyboardAppear(tap:)))
                    line.addGestureRecognizer(tapGr)
                    
                    //加入输入框
                    self.view.addSubview(inputText)
                    addConstraints(line: inputText)
                    
                    //加入读按钮
                    initButton(positionX: positionX[sentenceCount - 2][sentenceNum])
                    //加入检验按钮
                    initCheckButton()
                }
                
                addConstraints(line: line)
                sentenceNum += 1
                
            }
            
        }
        
    }
    
    func addConstraints(line: UIView){
        
        let positionX = self.positionX[sentenceCount - 2][sentenceNum]
        locate = positionX
        //添加约束
        
        line.superview!.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 100))
        
        line.superview!.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: CGFloat(positionX) ))
        
        line.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 400))
        
        line.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 35))
        
    }
    func addConstraintsNa(line: UIView){
        
        
        //添加约束
        
        line.superview!.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 160))
        
        line.superview!.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: CGFloat(locate)-70 ))
        
        line.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 400))
        
        line.addConstraint(NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 35))
        
    }
    
    //产生随机题号
    func blankID(lineLimit: Int) -> Int{
        let id = arc4random_uniform(4)
        
        return Int(id) >= lineLimit ? (lineLimit - 1) : Int(id)
    }
    
    //点击屏幕收起键盘
    func keyboardDisappear(tap: UITapGestureRecognizer){
        if nexton {
            return
        }
        
        
        
        inputText.resignFirstResponder()
        inputText.isHidden = true
        if(inputText.text == String()){
            poemlabel[blankNum].text = blankFrame
        } else{
            poemlabel[blankNum].text = inputText.text
        }
        readButton.isUserInteractionEnabled = true
    }
    
    func initInputText(){
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 28)
        inputText.textAlignment = .center
        inputText.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 0)
        inputText.delegate = self
        inputText.returnKeyType = UIReturnKeyType.done
        inputText.isHidden = true
        inputText.tintColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 0)
        //监听输入变化
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: .UITextFieldTextDidChange, object: inputText)
    }
    
    @objc private func textFieldDidChange(notification: NSNotification){
        let textField = notification.object as! UITextField
        
        if textField.text != blankFrame{
            
            poemlabel[blankNum].text = textField.text
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        fillIn = textField.text
        if(fillIn == String()){
            poemlabel[blankNum].text = blankFrame
            checkButton.isUserInteractionEnabled = false
        } else{
            poemlabel[blankNum].text = fillIn
            checkButton.setBackgroundImage(UIImage(named: "检验.png"), for: UIControlState.normal)
            checkButton.isUserInteractionEnabled = true
        }
        textField.isHidden = true
        readButton.isUserInteractionEnabled = true
        return true
    }
    
    //点击label弹出键盘
    func keyboardAppear(tap: UITapGestureRecognizer){
        inputText.isHidden = false
        poemlabel[blankNum].text = String()
        inputText.becomeFirstResponder()
        readButton.isUserInteractionEnabled = false
        checkButton.setBackgroundImage(UIImage(named: "检验.png"), for: UIControlState.normal)
    }
    
    func initButton(positionX: CGFloat){
        
        self.view.addSubview(readButton)
        
        readButton.translatesAutoresizingMaskIntoConstraints = false
        
        readButton.superview!.addConstraint(NSLayoutConstraint(item: readButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: poemlabel[blankNum], attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -10))
        
        readButton.superview!.addConstraint(NSLayoutConstraint(item: readButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: poemlabel[blankNum], attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))
        
        readButton.addConstraint(NSLayoutConstraint(item: readButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 48))
        
        readButton.addConstraint(NSLayoutConstraint(item: readButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 48))
        
        readButton.setBackgroundImage(UIImage(named: "诵印章.png"), for: UIControlState.normal)
        
        readButton.addTarget(self, action: #selector(record), for: .touchUpInside)
    }
    
    //readButton点击事件
    func record(){
        
        if ifClickRecord {
            Issuccess=false
            poemlabel[blankNum].text = blankFrame
            inputText.text = nil
            startRecording()
            inputText.isUserInteractionEnabled = false
            poemlabel[blankNum].isUserInteractionEnabled = false
            readButton.setBackgroundImage(UIImage(named: "按诵印章.png"), for: UIControlState.normal)
            checkButton.setBackgroundImage(UIImage(named: "检验.png"), for: UIControlState.normal)
            ifClickRecord = false
            checkButton.isUserInteractionEnabled = false
            //            checkButton.isEnabled = false
            poemlabel[blankNum].isUserInteractionEnabled = false
            //            inputText.isEnabled = false
            
        } else{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            inputText.isUserInteractionEnabled = true
            poemlabel[blankNum].isUserInteractionEnabled = true
            readButton.setBackgroundImage(UIImage(named: "诵印章.png"), for: UIControlState.normal)
            ifClickRecord = true
            checkButton.isUserInteractionEnabled = true
            //            checkButton.isEnabled = true
            poemlabel[blankNum].isUserInteractionEnabled = true
            //            inputText.isEnabled = true
            readcheck()
            self.checkIfRight()
            
        }
        
        //其他事件
    }
    
    static func openDB(){
        //打开数据库
        let path = Bundle.main.path(forResource: "poemsentence", ofType: "db")
//        let error = sqlite3_open_v2(path?.cString(using: .utf8), &singleViewController.db, SQLITE_OPEN_READONLY, nil)
        let error = sqlite3_open_v2(path?.cString(using: .utf8), &singleViewController.db, SQLITE_OPEN_READWRITE, nil)
        
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
            levelNum = level
        }
        
        let BGNum = ((level / 10) + 1) % 18
        
        backgroundPic.image = UIImage(named: ("PBG" + String(BGNum) + ".png"))
        
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
    
    
    //开始录音
    func startRecording() {
        
        if recognitionTask != nil {
            
            recognitionTask?.cancel()
            
            recognitionTask = nil
            
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
        } catch {
            
            print("audioSession properties weren't set because of an error.")
            
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            
            fatalError("Audio engine has no input node")
            
        }
        
        guard let recognitionRequest = recognitionRequest else {
            
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.userpoem = result?.bestTranscription.formattedString
                
                isFinal = (result?.isFinal)!
                
            }
            
            //答案匹配
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                
                //                if ((self.userpoem != nil)&&(self.blank != nil)){
                //                    var userstr = NSMutableString(string: self.userpoem!) as CFMutableString
                //
                //                    var userpinyin: String?
                //                    var dbpinyin: String?
                //
                //                    if CFStringTransform(userstr,nil, kCFStringTransformMandarinLatin, false) == true{
                //                        if CFStringTransform(userstr,nil, kCFStringTransformStripDiacritics, false) == true{
                //                            print(userstr)
                //                            //获取用户答案的拼音
                //                            userpinyin = userstr as String
                //
                //                        }
                //                    }
                //
                //                    var dbstr = NSMutableString(string: self.blank!) as CFMutableString
                //                    if CFStringTransform(dbstr,nil, kCFStringTransformMandarinLatin, false) == true{
                //                        if CFStringTransform(dbstr,nil, kCFStringTransformStripDiacritics, false) == true{
                //                            //获取数据库答案的拼音
                //                            dbpinyin = dbstr as String
                //                        }
                //                    }
                //
                //                    if (userpinyin != nil)&&(dbpinyin != nil){
                //                        self.Issuccess = self.checklike(strread: userpinyin!, strpoem: dbpinyin!)
                //                    }
                //
                //                }
                //                else{
                //
                //                    self.Issuccess = false
                //
                //                }
                
                
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                
                self.recognitionTask = nil
                
            }
            
        })
        
        
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            
            self.recognitionRequest?.append(buffer)
            
        }
        
        
        
        audioEngine.prepare()
        
        
        
        do {
            
            try audioEngine.start()
            
        } catch {
            
            print("audioEngine couldn't start because of an error.")
            
        }
        
        
        
    }
    
    
    func initCheckButton(){
        self.view.addSubview(checkButton)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        checkButton.superview!.addConstraint(NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: readButton, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 10))
        
        checkButton.superview!.addConstraint(NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: poemlabel[blankNum], attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))
        
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
        if fillIn == blank  {
            checkButton.setBackgroundImage(UIImage(named: "正确.png"), for: UIControlState.normal)
            poemlabel[blankNum].text = blank
            poemname()
            return
            
            
        } else if Issuccess{
            
            poemlabel[blankNum].text = blank
            poemname()
            checkButton.setBackgroundImage(UIImage(named: "正确.png"), for: UIControlState.normal)
            
            return
            
            
        } else if inputText.text == nil{
            return
        } else{
            checkButton.setBackgroundImage(UIImage(named: "错误.png"), for: UIControlState.normal)
            return
        }
        
        
        
    }
    
    //切换到下一题或者下一关
    func switchToNextPoem(slide: UISwipeGestureRecognizer){
        
        if slide.direction == UISwipeGestureRecognizerDirection.left && poemlabel[blankNum].text == blank {
            if(levelNum % 10 == 0||addition == 9){
                //                出现当前关卡名字，闯关成功界面，没有其他按钮 只能返回关卡界面
                
                readButton.removeFromSuperview()
                inputText.removeFromSuperview()
                checkButton.removeFromSuperview()
                for i in poemlabel{
                    i.removeFromSuperview()
                }
                
                if signOfSuccessDidAppear{
                    self.navigationController?.popViewController(animated: true)
                } else{
                    
                    let signOfSuccess = UILabel()
                    
                    signOfSuccess.text = "︻恭喜折桂︼"
                    signOfSuccess.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 28)
                    signOfSuccess.numberOfLines = 0
                    signOfSuccess.translatesAutoresizingMaskIntoConstraints = false
                    signOfSuccess.textAlignment = .center
                    signOfSuccess.textColor = UIColor(red: 114/255, green: 36/255, blue: 32/255, alpha: 1)
                    self.view.addSubview(signOfSuccess)
                    
                    signOfSuccess.superview!.addConstraint(NSLayoutConstraint(item: signOfSuccess, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 160))
                    
                    signOfSuccess.superview!.addConstraint(NSLayoutConstraint(item: signOfSuccess, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: singleViewController.width / 2 ))
                    
                    signOfSuccess.addConstraint(NSLayoutConstraint(item: signOfSuccess, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 400))
                    
                    signOfSuccess.addConstraint(NSLayoutConstraint(item: signOfSuccess, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 35))
                    
                    signOfSuccessDidAppear = true
                }
                
            } else{//下一题
                
                //初始化
                inputText.text = String()
                readButton.removeFromSuperview()
                inputText.removeFromSuperview()
                checkButton.removeFromSuperview()
                sentenceNum = 0
                ifClickRecord = true
                for i in poemlabel{
                    i.removeFromSuperview()
                }
                poemlabel.removeAll(keepingCapacity: false)
                
                initLabel()
                initable()
                
            }
            
        }
    }
    //恢复关卡
    func resumeLevel(){
        levelNum = UserDefaults.standard.integer(forKey: "level")
        
        if levelNum != 0{
            
            var count = 1
            
            while(count < levelNum - 1 && sqlite3_step(singleViewController.stmt) == SQLITE_ROW){
                
                count += 1
                
            }
        }
    }
    
    
    //匹配是否正确
    func checklike(strread: String,strpoem: String) -> Bool {
        
        var i = 0,j = 0,number=0
        let userlen = strread.characters.count
        let dblen = strpoem.characters.count
        
        while i<userlen-1&&j<dblen-1 {
            if((strread[strread.index(strread.startIndex, offsetBy: i)] == "l")||(strread[strread.index(strread.startIndex, offsetBy: i)] == "n"))&&(strpoem[strpoem.index(strpoem.startIndex, offsetBy: j)] == "l")||(strpoem[strpoem.index(strpoem.startIndex, offsetBy: j)] == "n"){
                number += 1
                i += 1
                j += 1
            }
            guard strread[strread.index(strread.startIndex, offsetBy: i)] == strpoem[strpoem.index(strpoem.startIndex, offsetBy: j)]  else{
                if (strread[strread.index(strread.startIndex, offsetBy: i)] == " "){
                    j += 1
                }
                if (strpoem[strpoem.index(strpoem.startIndex, offsetBy: j)] == " "){
                    i += 1
                }
                i += 1
                j += 1
                continue
                
            }
            number += 1
            i += 1
            j += 1
            
        }
        
        let bili = dblen/number
        print(bili)
        if dblen/number<=2{
            return true
        }
        
        return false
    }
    
    //出题名
    func poemname(){
        readButton.isUserInteractionEnabled = false
        checkButton.isUserInteractionEnabled = false
        inputText.isUserInteractionEnabled = false
        readButton.adjustsImageWhenDisabled=false
        checkButton.adjustsImageWhenDisabled=false
        poemlabel[blankNum].isUserInteractionEnabled = false
        
        //readButton.isEnabled = false
        //checkButton.isEnabled = false
        //        inputText.isEnabled = false
        
        
        //poemlabel[blankNum].isUserInteractionEnabled = false
        //        poemlabel[blankNum].isEnabled = false
        
        
        let level = Int(sqlite3_column_int(singleViewController.stmt, 0)) + 1
        
        if(UserDefaults.standard.integer(forKey: "level") < level){
            UserDefaults.standard.set(level, forKey: "level")
        }
        
        nexton = true
        
        let name = UILabel()
        name.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 20)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        poemlabel.append(name)
        name.textAlignment = .center
        name.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1)
        self.view.addSubview(name)
        
        name.isUserInteractionEnabled = true
        let tapJump = UITapGestureRecognizer(target: self, action: #selector(jumpTo))
        name.addGestureRecognizer(tapJump)
        
        name.text = dbname
        
        addConstraintsNa(line: name)
        
        addition += 1
        
        
    }
    
    func jumpTo(){
        
        self.performSegue(withIdentifier: "goView2", sender: self)
        
    }
    
    func readcheck(){
        if ((self.userpoem != nil)&&(self.blank != nil)){
            var userstr = NSMutableString(string: self.userpoem!) as CFMutableString
            
            var userpinyin: String?
            var dbpinyin: String?
            
            if CFStringTransform(userstr,nil, kCFStringTransformMandarinLatin, false) == true{
                if CFStringTransform(userstr,nil, kCFStringTransformStripDiacritics, false) == true{
                    print(userstr)
                    //获取用户答案的拼音
                    userpinyin = userstr as String
                    
                }
            }
            
            var dbstr = NSMutableString(string: self.blank!) as CFMutableString
            if CFStringTransform(dbstr,nil, kCFStringTransformMandarinLatin, false) == true{
                if CFStringTransform(dbstr,nil, kCFStringTransformStripDiacritics, false) == true{
                    //获取数据库答案的拼音
                    dbpinyin = dbstr as String
                }
            }
            
            if (userpinyin != nil)&&(dbpinyin != nil){
                self.Issuccess = self.checklike(strread: userpinyin!, strpoem: dbpinyin!)
            }
            
        }
        else{
            
            self.Issuccess = false
            
        }
        
    }
    
    func initable(){
        inputText.isUserInteractionEnabled = true
        inputText.isEnabled = true
        poemlabel[blankNum].isUserInteractionEnabled = true
        checkButton.isUserInteractionEnabled = true
        checkButton.isEnabled = true
        poemlabel[blankNum].isEnabled = true
        readButton.isEnabled=true
        readButton.isUserInteractionEnabled = true
    }
    
    
    
}

