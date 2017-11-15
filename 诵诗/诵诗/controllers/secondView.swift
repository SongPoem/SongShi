//
//  secondView.swift
//  诵诗
//
//  Created by mac on 2017/7/30.
//  Copyright © 2017年 mac. All rights reserved.
//

import Foundation


class secondView{
    
    static func reOrderSentence(s1: String, s2: String) ->  (Int, String) {
        var s = ""
        var temp = -1
        var rs = ""
        var s22 = s2
        
        var len = (s1+s2).characters.count
        if len == 10 {
            s22.remove(at: s22.index(before: s22.endIndex))
        }
        else if(len > 12 && len <= 16){
            while len > 12 {
                s22.remove(at: s22.index(before: s22.endIndex))
                len = (s1+s22).characters.count
            }
        }
        else if(len > 16){
            while len > 16 {
                s22.remove(at: s22.index(before: s22.endIndex))
                len = (s1+s22).characters.count
            }
        }
        s = s1 + s22
        
        for (_,_) in s.characters.enumerated(){
            temp = Int(arc4random() % UInt32(s.characters.count))
            let index = s.index(s.startIndex, offsetBy: temp)
            rs.append(s[index])
            s.remove(at: index)
        }
        print(rs)
        
        return (rs.characters.count, rs)
    }
    
}
