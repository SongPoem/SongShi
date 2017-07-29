//
//  entranceViewController.swift
//  诵诗
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class entranceViewController: UIViewController{
    @IBOutlet weak var loader1: UIImageView!
    @IBOutlet weak var loader2: UIImageView!
    @IBOutlet weak var loader3: UIImageView!
    
    @IBOutlet weak var buttonTitle: UILabel!
    @IBOutlet weak var left: UIImageView!
    @IBOutlet weak var right: UIImageView!
    @IBOutlet weak var onlyBut: UIStackView!
    
    private var layer = 1
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipToRight)))
        let gestToLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipToLeft))
        gestToLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(gestToLeft)
        
        onlyBut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toLevels)))
        
    }
    
    @IBAction func toLeftBut(_ sender: UIButton) {
        swipToLeft()
    }
    
    @IBAction func toRightBut(_ sender: UIButton) {
        swipToRight()
    }
    
    func swipToLeft() {
        if layer < 3 {
            layer += 1
        }
        swip()
    }
    
    func swipToRight() {
        if layer > 1 {
            layer -= 1
        }
        
        swip()
    }
    
    func swip(){
        UIView.animate(withDuration: 0.5, animations: {
            self.left.center.x += 80
        }, completion:{(finished: Bool) -> Void in
            UIView.animate(withDuration: 0.5, animations: {
                self.left.center.x -= 80
                switch self.layer {
                case 2:
                    self.buttonTitle.text = "诗结四海"
                    self.setLoader(a: false, b: true, c: false)
                case 3:
                    self.buttonTitle.text = "驻足赏诗"
                    self.setLoader(a: false, b: false, c: true)
                default:
                    self.buttonTitle.text = "四季如诗"
                    self.setLoader(a: true, b: false, c: false)
                }
            })
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.right.center.x -= 82
        }, completion:{(finished: Bool) -> Void in
            UIView.animate(withDuration: 0.5, animations: {
                self.right.center.x += 82
            })
        })
    }
    
    func toLevels(){
        performSegue(withIdentifier: "toLevels", sender: self)
        print("yes")
        
    }
    
    func setLoader(a: Bool, b: Bool, c: Bool) {
        if a {
            loader1.image = UIImage(named:"noPoint")
        }else{
            loader1.image = UIImage(named:"point")
        }
        
        if b {
            loader2.image = UIImage(named:"noPoint")
        }else{
            loader2.image = UIImage(named:"point")
        }
        
        if c{
            loader3.image = UIImage(named:"noPoint")
        }else{
            loader3.image = UIImage(named:"point")
        }
    }
    
    
    
}
