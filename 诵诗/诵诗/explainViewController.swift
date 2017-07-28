//
//  explainViewController.swift
//  诵诗
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class explainViewController: UIViewController{
    
    
    let poemName = UILabel()
    let poet = UILabel()
    let poem = UITextView()
    
    var poemText = String()
    
    var stmt: OpaquePointer? = nil
    
    
    @IBOutlet weak var poetry: UIButton!
    
    @IBOutlet weak var explanation: UIButton!
    
    @IBOutlet weak var translation: UIButton!
    
    @IBOutlet weak var backToMenu: UIButton!
    
    @IBOutlet weak var maskView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStatement()
        initBackground()
        setPoemTitle()
        setPoet()
        setPoem()
        setMask()
        
        self.navigationController?.isNavigationBarHidden = false
        
        let tapJumpTo = UITapGestureRecognizer(target: self, action: #selector(jumpTo))
        backToMenu.addGestureRecognizer(tapJumpTo)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
    }
    
    
    func poemIntegrate() {
        var a = 0
        for i in poemText.characters {
            a += 1
            if (i == "，" || i == "。" || i == "？" || i ==  "；" || i ==  "、") {
                poemText.insert("\n", at: poemText.index(poemText.startIndex, offsetBy: a))
                a += 1
                poemText.insert("\n", at: poemText.index(poemText.startIndex, offsetBy: a))
                a += 1
            }
        }
        poem.text = poemText
    }
    
    func setPoemTitle() {
        poemName.translatesAutoresizingMaskIntoConstraints = false
        
        poemName.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 24)
        poemName.translatesAutoresizingMaskIntoConstraints = false
        poemName.textAlignment = .center
        poemName.textColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
        
        self.view.addSubview(poemName)
        
        //添加约束
        poemName.superview?.addConstraint(NSLayoutConstraint(item: poemName, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 70))
        
        poemName.superview?.addConstraint(NSLayoutConstraint(item: poemName, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))
        
        poemName.addConstraint(NSLayoutConstraint(item: poemName, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 35))
        
        poemName.addConstraint(NSLayoutConstraint(item: poemName, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: UIScreen.main.bounds.width))
        
        if let temp = UnsafePointer(sqlite3_column_text(stmt, 1)){
            poemName.text = String.init(cString: temp)
        } else{
            poemName.text = String("error")
        }
        
        poemName.adjustsFontSizeToFitWidth = true
        
    }
    
    func setPoet(){
        
        poet.translatesAutoresizingMaskIntoConstraints = false
        poet.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        
        self.view.addSubview(poet)
        
        poet.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 20)
        poet.translatesAutoresizingMaskIntoConstraints = false
        poet.textAlignment = .center
        poet.textColor = UIColor(red: 31/255, green: 89/255, blue: 107/255, alpha: 1)
        
        //添加约束
        poet.superview?.addConstraint(NSLayoutConstraint(item: poet, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: poemName, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 10))
        
        poet.superview?.addConstraint(NSLayoutConstraint(item: poet, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))
        
        poet.addConstraint(NSLayoutConstraint(item: poet, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: 30))
        
        poet.addConstraint(NSLayoutConstraint(item: poet, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: UIScreen.main.bounds.width))
        
        if let temp = UnsafePointer(sqlite3_column_text(stmt, 2)){
            poet.text = String.init(cString: temp)
        } else{
            poet.text = String("error")
        }
    }
    
    func setPoem(){
        poem.translatesAutoresizingMaskIntoConstraints = false
        poem.isEditable = false
        poem.isScrollEnabled = true
        poem.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 237/255, blue: 233/255, alpha: 0)
        
        self.view.addSubview(poem)
        
        poem.translatesAutoresizingMaskIntoConstraints = false

        
        
        //添加约束
        poem.superview?.addConstraint(NSLayoutConstraint(item: poem, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: poet, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 20))
        
        poem.superview?.addConstraint(NSLayoutConstraint(item: poem, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 20))
        
        poem.superview?.addConstraint(NSLayoutConstraint(item: poem, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: -20))
        
        poem.superview?.addConstraint(NSLayoutConstraint(item: poem, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
        
        self.view.sendSubview(toBack: poem)
        
        if let temp = UnsafePointer(sqlite3_column_text(stmt, 8)){
            poemText = String.init(cString: temp)
            poemIntegrate()
        }
        
        for _ in 0 ... 7{
            poemText.insert("\n", at: poemText.endIndex)
        }
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 10
        let attribute = [NSParagraphStyleAttributeName: para, NSFontAttributeName: UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 18), NSForegroundColorAttributeName: UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)]
        
        poem.attributedText = NSAttributedString(string: poemText, attributes: attribute)
        
        poem.textAlignment = .center

    }
    
    func getStatement(){
        
        stmt = singleViewController.stmt
        
    }
    
    @IBAction func getPoemText(_ sender: Any) {
        poetry.isSelected = true
        translation.isSelected = false
        explanation.isSelected = false
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 10
        let attribute = [NSParagraphStyleAttributeName: para, NSFontAttributeName: UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 18), NSForegroundColorAttributeName: UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)]
        
        poem.attributedText = NSAttributedString(string: poemText, attributes: attribute)
        
        poem.textAlignment = .center
        
        self.view.sendSubview(toBack: poem)
    }
    
    
    @IBAction func getPoemExplanation(_ sender: Any) {
        poetry.isSelected = false
        translation.isSelected = false
        explanation.isSelected = true
        
        if let temp = UnsafePointer(sqlite3_column_text(stmt, 10)){
            
            var explanation = String.init(cString: temp)
            
            var countOfFullStop = 0
            var countOfCharacter = 0
            for i in explanation.characters {
                
                if (i == "。" ) {
                    countOfFullStop += 1
                    
                    let random = arc4random_uniform(10) + 3
                    
                    if(Double(countOfFullStop).truncatingRemainder(dividingBy: Double(random)) == 0)
                    {
                        explanation.insert("\n", at: explanation.index(explanation.startIndex, offsetBy: countOfCharacter + 1))
                        countOfCharacter += 1
                        explanation.insert("\n", at: explanation.index(explanation.startIndex, offsetBy: countOfCharacter))
                        countOfCharacter += 1
                    }
                    
                    
                }
                countOfCharacter += 1
            }
            
            for _ in 0 ... 7{
                explanation.insert("\n", at: explanation.endIndex)
            }
            
            let para = NSMutableParagraphStyle()
            para.lineSpacing = 10
            let attribute = [NSParagraphStyleAttributeName: para, NSFontAttributeName: UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 18), NSForegroundColorAttributeName: UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)]
            
            poem.attributedText = NSAttributedString(string: explanation, attributes: attribute)
            
        } else{
            poem.text = "您当前查看的诗无赏析"
        }
        
        poem.textAlignment = .justified
        
        self.view.sendSubview(toBack: poem)
    }
    
    
    @IBAction func getPoemTramslation(_ sender: Any) {
        
        poetry.isSelected = false
        translation.isSelected = true
        explanation.isSelected = false
        
        if let temp = UnsafePointer(sqlite3_column_text(stmt, 9)){
            var translation = String.init(cString: temp)
            
            for _ in 0 ... 7{
                translation.insert("\n", at: translation.endIndex)
            }
            
            let para = NSMutableParagraphStyle()
            para.lineSpacing = 10
            let attribute = [NSParagraphStyleAttributeName: para, NSFontAttributeName: UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 18), NSForegroundColorAttributeName: UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)]
            
            poem.attributedText = NSAttributedString(string: translation, attributes: attribute)
            
            
        } else{
            poem.text = "您当前查看的诗无翻译"
        }
        
        
        
        poem.textAlignment = .justified
        
        self.view.sendSubview(toBack: poem)
        
    }
    
    func jumpTo(){
        self.performSegue(withIdentifier: "gobackToMenu", sender: self);
    }
    
    
    
    func initBackground(){
        
        poetry.setImage(UIImage(named: "全文未选中.png"), for: UIControlState.normal)
        poetry.setImage(UIImage(named: "全文选中.png"), for: UIControlState.selected)
        
        poetry.isSelected = true
        
        translation.setImage(UIImage(named: "译文未选中.png"), for: UIControlState.normal)
        translation.setImage(UIImage(named: "译文选中.png"), for: UIControlState.selected)
        
        explanation.setImage(UIImage(named: "赏析未选中.png"), for: UIControlState.normal)
        explanation.setImage(UIImage(named: "赏析选中.png"), for: UIControlState.selected)
        
        
        backToMenu.setImage(UIImage(named: "返回主界面未选中.png"), for: UIControlState.normal)
        backToMenu.setImage(UIImage(named: "返回主界面选中.png"), for: UIControlState.selected)
    }
    
    func setMask(){
        
        self.view.insertSubview(maskView, aboveSubview: poem)
        
    }
    
}








