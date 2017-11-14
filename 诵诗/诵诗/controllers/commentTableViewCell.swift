//
//  commentTableViewCell.swift
//  诵诗
//
//  Created by mac on 2017/10/20.
//  Copyright © 2017年 mac. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class commentTableViewCell: UITableViewCell{
    var imgView: UIImageView?
    var titleLab:UILabel?
    var despLab:UILabel?
    var midLab:UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        //初始化头像
        imgView = UIImageView()
//        imgView?.image = UIImage.init(named: "defaultAvatar")
        imgView?.layer.cornerRadius = (imgView?.frame.height)!/2.0
        imgView?.layer.masksToBounds = true
        self.addSubview(imgView!)
        
        //顶部的label 初始化
        let label1 = UILabel()
        label1.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 18)
        label1.textColor = UIColor.black
        label1.numberOfLines = 0
        self.addSubview(label1)
        titleLab = label1
        
        //中间的label初始化
        let label3 = UILabel()
        label3.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 13)
        label3.textColor = UIColor.lightGray
        self.addSubview(label3)
        midLab = label3
        
        //底部的label 初始化
        let label2 = UILabel()
        label2.font = UIFont(name:"FZQingKeBenYueSongS-R-GB", size: 14)
        label2.textColor = UIColor.darkGray
        label2.numberOfLines = 0
        self.addSubview(label2)
        despLab = label2
        
        
        //设置布局 SnapKit  --- >相当去Objective-C中的Masonry
        imgView?.snp.makeConstraints({ (make) in
            make.top.left.equalTo(30)
            make.width.height.equalTo(40)
        })
        
        label1.snp.makeConstraints { (make) in
            make.top.equalTo((imgView?.snp.top)!)
            make.left.equalTo((imgView?.snp.right)!).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(21)
        }
        
        label3.snp.makeConstraints{ (make) in
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.left.equalTo(label1.snp.left)
            make.right.equalTo(-10)
            make.height.equalTo(21)
        }
        
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(label3.snp.bottom).offset(20)
            make.left.equalTo((label1.snp.left))
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
        
    }
}
