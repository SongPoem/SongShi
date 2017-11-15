//
//  informationViewController.swift
//  诵诗
//
//  Created by Lin on 2017/10/19.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class informationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate {
    
    var imagePickerController: UIImagePickerController?
    var uploadAlertViewController: UIAlertController?
    var stmt: OpaquePointer?
//    @IBOutlet weak var tableview: UITableView!
    var tableview: UITableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.attributedText = NSAttributedString(string: "更换头像", attributes: [NSAttributedStringKey.font: UIFont.init(name: "FZQingKeBenYueSongS-R-GB", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.init(red: 35/255.0, green: 98/255.0, blue: 118/255.0, alpha: 1)])
        
        let toPhotoLib = UIImageView(frame: CGRect(x: (tableview?.bounds.width)! * 0.9, y: 25, width: 20, height: 20))
        toPhotoLib.image = UIImage(named: "左箭头.png")
        
        cell.contentView.addSubview(toPhotoLib)
        cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        awakePickerView()
    }
    
    func initAlertController() {
        self.uploadAlertViewController =  UIAlertController(title:nil, message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        //self.uploadAlertController.view.tintColor = DeepMainColor
        let photoLib = UIAlertAction(title:"从相册选择", style:UIAlertActionStyle.default) { (action: UIAlertAction)in
            self.getImageFromPhotoLib(type: .photoLibrary)
        }
        let cancel = UIAlertAction(title:"取消", style:UIAlertActionStyle.cancel) { (action: UIAlertAction) in
        }
        self.uploadAlertViewController?.addAction(photoLib)
        self.uploadAlertViewController?.addAction(cancel)
    }
    
    func initImagePickerController()
    {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController?.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // 设置是否可以管理已经存在的图片或者视频
        self.imagePickerController?.allowsEditing = true
    }
    
    func getImageFromPhotoLib(type:UIImagePickerControllerSourceType)
    {
        self.imagePickerController?.sourceType = type
        //判断是否支持相册
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            self.present(imagePickerController!, animated: true, completion: nil)
            performSegue(withIdentifier: "toPhotoLib", sender: self)
        }
    }
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]){
        
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        //当选择的类型是图片
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imgData = UIImagePNGRepresentation(img!)
        var stmt: OpaquePointer?
        let sql = "UPDATE user SET avatar = \(String(describing: imgData?.base64EncodedData())) WHERE gameCenterId = \(String(describing: GameCenterMatch.getLocalPlayerId()))".cString(using: .utf8)
        
        let prepare_result = sqlite3_prepare_v2(singleViewController.db, sql!, -1, &stmt, nil)
        
        //判断如果失败，获取失败信息
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(String(describing: sql))"
                print(msg)
            }
        }
        
        //step执行
        let step_result = sqlite3_step(stmt)
        
        //判断执行结果，如果失败，获取失败信息
        if step_result != SQLITE_OK && step_result != SQLITE_DONE {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to execute SQL:\(sql)"
                print(msg)
            }
        }
        
        //finalize
        sqlite3_finalize(stmt)
        
        picker.dismiss(animated:true, completion:nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
    
    func initBG() {
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bg.image = UIImage(named: "infoBG.png")
        bg.alpha = 0.7
        self.view.addSubview(bg)
        
        let leftBarItem = UIBarButtonItem(title: "< 编辑资料", style: .plain, target: self, action: #selector(back))
        leftBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.init(name: "FZQingKeBenYueSongS-R-GB", size: 20)!], for: .normal)
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func initTableView() {
        tableview = UITableView(frame: CGRect(x: 0.05 * self.view.bounds.width, y: 0.1 * self.view.bounds.height, width: self.view.bounds.width * 0.9, height: self.view.bounds.height), style: .plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(tableview!)
        self.tableview?.tableFooterView = UIView()
    }
    
    @objc func awakePickerView() {
        self.present(self.uploadAlertViewController!, animated: true, completion: nil)
    }
    
    @objc func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBG()
        initTableView()
        initAlertController()
        initImagePickerController()
        self.tableview?.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


