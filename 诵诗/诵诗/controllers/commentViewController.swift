//
//  commentViewController.swift
//  诵诗
//
//  Created by mac on 2017/10/17.
//  Copyright © 2017年 mac. All rights reserved.
//

import Foundation
import UIKit

class commentViewController: ViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    private var Title:UILabel = UILabel()
    private var subTitle = UILabel()
    private var comBut = UIButton()
    private var commentView: UIView!
    
    static var stmt:OpaquePointer? = nil
    
    private var ids: Array<Int> = []
    private var contents: Array<String> = []
    private var dates: Array<String> = []
    private var names: Array<String> = []
    
    private var commentText = ""
    private var poemId = -1
    
    static var DB:SQLiteDB!
    
    @IBOutlet weak var commentTable: UITableView!
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 237/255, alpha: 1)
        poemId = UserDefaults.standard.integer(forKey: "poemChosen")
        setTitile()
        
        title = UserDefaults.standard.string(forKey: "poemName")
        self.navigationController?.navigationBar.titleTextAttributes = {[
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 18)!
            ]}()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        setTable()
        getComment()
        getUserInfo()
        setButton()
        commentTable.tableFooterView = UIView()
//        openDataBase()
        
        
    }
    
//    func openDataBase(){
//        //获取数据库实例
//        commentViewController.DB = SQLiteDB.shared
////        commentViewController.DB.DB_NAME = "poemsentence"
//        //打开数据库
//        _ = commentViewController.DB.openDB()
//    }
//

    func setTable(){
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.register(commentTableViewCell.self, forCellReuseIdentifier: "cCell")
        commentTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        commentTable.estimatedRowHeight = 44.0
        commentTable.rowHeight = UITableViewAutomaticDimension
        commentTable.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 237/255, alpha: 1)
    }
    
    func setButton(){
        comBut.frame = CGRect(x: self.view.bounds.width*0.7, y:self.view.bounds.height*0.85, width: 50, height: 50)
        comBut.setImage(UIImage(named: "comment"), for: .normal)
        comBut.layer.cornerRadius = 25
        comBut.layer.shadowColor = UIColor.lightGray.cgColor
        comBut.layer.shadowOpacity = 1
        comBut.layer.shadowOffset = CGSize(width: 2, height: 6)
        comBut.layer.borderWidth = 1
        comBut.layer.borderColor = UIColor(red: 243/255, green: 241/255, blue: 237/255, alpha: 1).cgColor
        comBut.backgroundColor = .white
        comBut.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
        self.view.addSubview(comBut)
    }
    
    @objc func clickToComment(){
        commentView = UIView(frame: CGRect(x: self.view.bounds.width/10, y: self.view.bounds.height/3, width: 280, height: 200))
        commentView.layer.cornerRadius = 6
        commentView.backgroundColor = .white
        commentView.layer.shadowOffset = CGSize(width: 2, height: 4)
        commentView.layer.shadowColor = UIColor.lightGray.cgColor
        commentView.layer.shadowOpacity = 0.8
        commentView.layer.shadowRadius = 8
        commentView.layer.borderColor = UIColor(red: 216/255, green: 195/255, blue: 184/255, alpha: 1).cgColor
        self.view.addSubview(commentView)
        
        let commentField = UITextView(frame: CGRect(x: 20, y: 50, width: 240, height: 140))
//        commentField.placeholder = "请输入评论"
        commentField.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 14)
        commentField.isEditable = true
        commentField.adjustsFontForContentSizeCategory = true
        commentField.keyboardType = UIKeyboardType.default
        commentField.delegate = self
        commentView.addSubview(commentField)
        
        let cancelBut = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 25))
        cancelBut.titleLabel?.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 16)
        cancelBut.setTitle("取消", for: .normal)
        cancelBut.setTitleColor(UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1), for: .normal)
        cancelBut.setTitleColor(UIColor.darkGray, for: .selected)
        cancelBut.addTarget(self, action: #selector(commentViewController.delCV), for: .touchUpInside)
        commentView.addSubview(cancelBut)
        
        let okBut = UIButton(frame: CGRect(x: 220, y: 20, width: 40, height: 25))
        okBut.titleLabel?.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 16)
        okBut.setTitle("发表", for: .normal)
        okBut.setTitleColor(UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1), for: .normal)
        okBut.setTitleColor(UIColor.darkGray, for: .selected)
        okBut.addTarget(self, action: #selector(commentViewController.addComment), for: .touchUpInside)
        commentView.addSubview(okBut)
        
        comBut.isEnabled = false
        
    }
    
    static func compile(sql: String){
        //编译
        if sqlite3_prepare_v2(singleViewController.db, sql.cString(using: .utf8), -1, &commentViewController.stmt, nil) != SQLITE_OK {
            sqlite3_finalize(commentViewController.stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
                print(String.init(cString: sqlite3_errmsg(singleViewController.db)))
            }
            sqlite3_close(singleViewController.db)
        }
    }
    
    
    
    func setTitile(){
        Title.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 20)
        Title.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1)
        Title.text = "评论"
        Title.frame = CGRect(x: view.bounds.maxX*0.08, y:view.bounds.maxY*0.08, width: view.bounds.width, height: view.bounds.height*0.1)
        
        self.view.addSubview(Title)
    }
    
    @objc func delCV(){
        commentView.removeFromSuperview()
        comBut.isEnabled = true
    }
    
    func getComment(){
        ids.removeAll()
        contents.removeAll()
        dates.removeAll()
        let sql = "SELECT userId, content, date FROM comment WHERE poemId = \(poemId);"
        print(sql)
        commentViewController.compile(sql: sql)
        while sqlite3_step(commentViewController.stmt) == SQLITE_ROW{
            let userId = UnsafePointer(sqlite3_column_text(commentViewController.stmt, 0))
            ids.append(Int(String.init(cString: userId!))!)
            
            let content = UnsafePointer(sqlite3_column_text(commentViewController.stmt, 1))
            contents.append(String.init(cString: content!))
            
            let date = String.init(cString: UnsafePointer(sqlite3_column_text(commentViewController.stmt, 2))!)
            dates.append(getAccDate(date: date))
        }
        
        contents.append(UserDefaults.standard.string(forKey: "tempComment")! )
        dates.append(UserDefaults.standard.string(forKey: "tempDate")!)
        ids.append(1)
    }
    
    func getUserInfo(){
        for (i, v) in ids.enumerated() {
            let sql = "SELECT userName FROM user WHERE userId = \(v);"
            commentViewController.compile(sql: sql)
            if sqlite3_step(commentViewController.stmt) == SQLITE_ROW{
                let userName = UnsafePointer(sqlite3_column_text(commentViewController.stmt, 0))
                names.append(String.init(cString: userName!))
            }else{
                contents.remove(at: i)
                dates.remove(at: i)
                ids.remove(at: i)
            }
        }
        
    }
    
    func getAccDate(date: String) -> String{
        var year = date.components(separatedBy:"-").first!
        if Int(year) == 2017{
            year = ""
        }else{
            year += "年"
        }
        let month = date.components(separatedBy:"-")[1] + "月"
        let day = date.components(separatedBy:"-")[2] + "日"
        return year+month+day
        
    }
    
    func execSQL(SQL : String) -> Bool {
        // 1.将sql语句转成c语言字符串
        let cSQL = SQL.cString(using: String.Encoding.utf8)
        //错误信息
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        if sqlite3_exec(singleViewController.db, cSQL, nil, nil, errmsg) == SQLITE_OK {
            return true
        }else{
            print("SQL 语句执行出错 -> 错误信息: 一般是SQL语句写错了 \(String(describing: errmsg))")
            return false
        }
    }
    
    @objc func addComment(){
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let customDate = dateformatter.string(from: date)
//        let sql = "INSERT INTO comment (commentId, userId, poemId, content, date) VALUES (1002, 1, 1, \"\(commentText)\", \"\(customDate)\");"
//        print(sql)
//        if execSQL(SQL: sql) {
//            print("插入数据成功")
//        }else{
//            print("插入数据fail")
//        }
        
        UserDefaults.standard.set(commentText, forKey: "tempComment")
        UserDefaults.standard.set(customDate, forKey: "tempDate")
        
//        let rid = sqlite3_last_insert_rowid(singleViewController.db)
//
//        let result = commentViewController.DB.execute(sql: sql)
//        print(result)
        
        //refresh
        getComment()
        commentTable.reloadData()
        commentView.removeFromSuperview()
        commentTable.reloadData()
        print(contents.count)
        
    }
    
    //protocal of tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTable.dequeueReusableCell(withIdentifier: "cCell", for: indexPath) as! commentTableViewCell
        cell.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 237/255, alpha: 1)
        
        //set image
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "AppIcon")
        imgView.frame = CGRect(x: 15, y: 35, width: 50, height: 50)
        imgView.layer.cornerRadius = (imgView.frame.height)/2.0
        imgView.layer.masksToBounds = true
        cell.addSubview(imgView)
        
        //
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 3
        let attributes = [NSAttributedStringKey.paragraphStyle: paraph]
        cell.despLab?.attributedText = NSAttributedString(string: "", attributes: attributes)
        
        cell.titleLab?.text = names[indexPath.row]
        cell.midLab?.text = dates[indexPath.row]
        cell.despLab?.text = contents[indexPath.row]
        
        return cell
        
    }
    
    //protocal of textField
    // 输入框按下键盘 return 收回键盘
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("我已经结束编辑状态...")
        commentText = textView.text!
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        //文本视图内容改变时，触发本方法，能得到改变的坐标和改变的内容
        commentText = textView.text!
        return true
    }
    

    

}
