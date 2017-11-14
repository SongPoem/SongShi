//
//  Register.swift
//  诵诗
//
//  Created by Lin on 2017/7/29.
//  Copyright © 2017年 mac. All rights reserved.
//

import Foundation
import UIKit

class registerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTextField(){
        
        username.borderStyle = .none
        username.attributedPlaceholder = NSAttributedString(string: "【          用户名           】", attributes: [NSAttributedStringKey.font: UIFont.init(name: "FZQingKeBenYueSongS-R-GB", size: 19.0)!, NSAttributedStringKey.foregroundColor: UIColor.init(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1)])
        username.delegate = self
        
        passwd.borderStyle = .none
        passwd.attributedPlaceholder = NSAttributedString(string: "【            密码             】", attributes: [NSAttributedStringKey.font: UIFont.init(name: "FZQingKeBenYueSongS-R-GB", size: 19.0)!, NSAttributedStringKey.foregroundColor: UIColor.init(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1)])
        passwd.delegate = self
        
        confirmPwd.borderStyle = .none
        confirmPwd.attributedPlaceholder = NSAttributedString(string: "【         确认密码        】", attributes: [NSAttributedStringKey.font: UIFont.init(name: "FZQingKeBenYueSongS-R-GB", size: 19.0)!, NSAttributedStringKey.foregroundColor: UIColor.init(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1)])
        confirmPwd.delegate = self
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        passwd.resignFirstResponder()
        confirmPwd.resignFirstResponder()
    }
    
    //监听键盘弹出事件
    @objc func keyboardWillShow(note: NSNotification) {
        
        
        let userInfo = note.userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        
        UIView.animate(withDuration: duration, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -deltaY)
        })
        
    }
    
    //监听键盘隐藏事件：
    @objc func keyboardWillHidden(note: NSNotification) {
        
        let userInfo = note.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        UIView.animate(withDuration: duration, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [ NSAttributedStringKey.foregroundColor: UIColor.init(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 0)])
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [ NSAttributedStringKey.foregroundColor: UIColor.init(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1)])
    }
}
