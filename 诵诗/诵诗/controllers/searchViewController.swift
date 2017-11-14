//
//  searchViewController.swift
//  诵诗
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 mac. All rights reserved.
//

import Foundation
import UIKit

class searchViewController: ViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var alignBut1: UIButton!
    @IBOutlet weak var alignBut2: UIButton!
    @IBOutlet weak var alignBut3: UIButton!
    @IBOutlet var search: UISearchBar!
    @IBOutlet weak var displayTable: UITableView!
    
    private var steps = 1.0
    private var currentLoc = 1.0
    private var lastBut = UIButton()
    private var chosen = UIImageView()
    private var theme = ""
    private var poemName:Array<String> = []
    private var poet:Array<String> = []
    private var poetFor2: Array<String> = []
    private var poem:Array<String> = []
    private var ids:Array<Int> = []
    static var cmpt = -1
    private var indexSet: Array<IndexPath> = []
    static var stmt:OpaquePointer? = nil
    //从搜索界面进入
    static var flag = false
    
    override func viewDidLoad() {
        // initiate slideImage
        lastBut = alignBut1
        if UIScreen.main.bounds.width < 375.0{
            chosen = UIImageView(frame: CGRect(x: lastBut.frame.maxX, y: alignBut1.center.y+100, width: 60, height: 5))
        }else{
            chosen = UIImageView(frame: CGRect(x: lastBut.center.x, y: alignBut1.center.y+100, width: 60, height: 5))
        }
        chosen.image = UIImage(named: "rec")
        self.view.addSubview(chosen)
        
        let rightNavBarButton = UIBarButtonItem(customView:search)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        search.keyboardType = .default
        search.isSecureTextEntry = false
        search.delegate = self
        
        let cancelButton = search.value(forKey: "cancelButton") as! UIButton
        cancelButton.setTitle("搜索", for: .normal)
        cancelButton.setTitleColor(UIColor(red:35/255.0, green: 98/255.0, blue: 118/255.0, alpha: 1), for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 16)
        
        displayTable.delegate = self
        displayTable.dataSource = self
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        displayTable.tableFooterView = UIView()
        searchViewController.flag = true
    }
    
    func queryByTheme(){
        var sql = "SELECT poem_name, poet, poem FROM s_poem;"
        //查询语句
        switch currentLoc {
        case 1.0:
            sql = "SELECT ID, poem_name, poet, poem FROM s_poem WHERE poem_name LIKE '%\(theme)%';"
        case 2.0:
            sql = "SELECT ID, poem_name, poet, poem FROM s_poem WHERE poet LIKE '%\(theme)%';"
        case 3.0:
            sql = "SELECT ID, poem_name, poet, poem FROM s_poem WHERE poem LIKE '%\(theme)%';"
        default:
            break
        }
        searchViewController.compile(sql: sql)
        print(sql)
    }
    
    static func compile(sql: String){
        //编译
        if sqlite3_prepare_v2(singleViewController.db, sql.cString(using: .utf8), -1, &searchViewController.stmt, nil) != SQLITE_OK {
            sqlite3_finalize(searchViewController.stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
                print(String.init(cString: sqlite3_errmsg(singleViewController.db)))
            }
            sqlite3_close(singleViewController.db)
        }
    }
    
    
    @IBAction func isChosen1(_ sender: UIButton) {
        moveImage(cur: 1.0, sender: sender)
    }
    
    @IBAction func isChosen2(_ sender: UIButton) {
        moveImage(cur: 2.0, sender: sender)
        
    }
    
    @IBAction func isChosen3(_ sender: UIButton) {
        moveImage(cur: 3.0, sender: sender)
    }
    
    func moveImage(cur: Double, sender: UIButton) {
        let lastLoc = currentLoc
        currentLoc = cur
        steps = cur - lastLoc
        UIView.animate(withDuration: 0.3, animations: {
            self.chosen.center.x += CGFloat(self.steps*(abs(Double(self.alignBut1.center.x - self.alignBut2.center.x))))
        })
        
        if sender != lastBut {
            sender.setTitleColor(UIColor(red:35/255.0, green: 98/255.0, blue: 118/255.0, alpha: 1), for: .normal)
            lastBut.titleLabel?.textColor = UIColor.darkGray
            lastBut = sender
        }
        
        reloadCell()
    }
    
    func reloadCell() {
        queryByTheme()
        getAllContent()
        displayTable.reloadData()
    }
    
    //protocal of search bar
    
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar){
//        print(search.text!)
        theme = search.text!
        reloadCell()
    }
    
    override func touchesBegan(_ touches:Set<UITouch>, with event:UIEvent?) {
        search.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar:UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar:UISearchBar) {
        theme = search.text!
        reloadCell()
    }
    
    
    //protocal of tableView
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let sql = "SELECT * FROM s_poem WHERE poem_name = \"\(poemName[indexPath.row])\";"
        searchViewController.compile(sql: sql)
        if sqlite3_step(searchViewController.stmt) == SQLITE_ROW{
            searchViewController.flag = true
        }
        
        performSegue(withIdentifier: "toExplain", sender: self)
    }
    
    func getAllContent() {
        poemName.removeAll()
        poet.removeAll()
        poem.removeAll()
        
        while sqlite3_step(searchViewController.stmt) == SQLITE_ROW {
            let id = UnsafePointer(sqlite3_column_text(searchViewController.stmt, 0))
            let poem_name = UnsafePointer(sqlite3_column_text(searchViewController.stmt, 1))
            let p = UnsafePointer(sqlite3_column_text(searchViewController.stmt, 2))
            let pm = UnsafePointer(sqlite3_column_text(searchViewController.stmt, 3))
            ids.append(Int(String.init(cString: id!))!)
            poemName.append(String.init(cString: poem_name!))
            poet.append("\n" + String.init(cString: p!) + "\n")
            poem.append(String.init(cString: pm!))
        }
//        poetFor2 = poet
//        poetFor2.sort(by: {
//            $1 < $0
//        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier="Cells";
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        if theme != "" {
            print(currentLoc)
            
            cell.textLabel?.text = poemName[indexPath.row]
            cell.textLabel?.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 18)
            cell.textLabel?.textColor = UIColor.darkGray
            
            cell.detailTextLabel?.numberOfLines = 3
            cell.detailTextLabel?.text = poet[indexPath.row]
            cell.detailTextLabel?.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 14)
            cell.detailTextLabel?.textColor = UIColor(red:35/255.0, green: 98/255.0, blue: 118/255.0, alpha: 1)
            
            let poemLabel = UILabel(frame: CGRect(x: (cell.bounds.maxX) * 0.07, y: (cell.center.y) + (cell.frame.maxY) * 2, width: 300, height: 20))
            poemLabel.text = poem[indexPath.row]
            poemLabel.textColor = UIColor.darkGray
            poemLabel.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 16)
            cell.contentView.addSubview(poemLabel)
            
            indexSet.append(indexPath)
        }
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let a = poemName.count
        return a
        
    }
    
    
}
