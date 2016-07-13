//
//  MonsterImg.swift
//  monster
//
//  Created by user on 7/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func playIdleAnimation(monster:Int){
        var imgArray = [UIImage]()
        if monster == 0 {
            self.image = UIImage(named: "idle1.png")
            
            self.animationImages = nil
            
            for var x=1; x <= 4; x++ {
                let img = UIImage(named: "idle\(x).png")
                imgArray.append(img!)
            }
        } else {
            self.image = UIImage(named: "blue_idle1.png")
            
            self.animationImages = nil
            
            for var x=1; x <= 4; x++ {
                let img = UIImage(named: "blue_idle\(x).png")
                imgArray.append(img!)
            }
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func deathAnimation(monster:Int){
        var imgArray = [UIImage]()
        if monster == 0 {
            self.image = UIImage(named: "dead1.png")
            
            self.animationImages = nil
            
            for var x=1; x <= 5; x++ {
                let img = UIImage(named: "dead\(x).png")
                imgArray.append(img!)
            }
            self.image = UIImage(named: "dead5.png")
        } else {
            self.image = UIImage(named: "blue_dead1.png")
            
            self.animationImages = nil
            
            for var x=1; x <= 3; x++ {
                let img = UIImage(named: "blue_dead\(x).png")
                imgArray.append(img!)
            }
            self.image = UIImage(named: "blue_dead3.png")
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
}