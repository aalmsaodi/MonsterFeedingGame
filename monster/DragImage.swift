//
//  DragImage.swift
//  monster
//
//  Created by user on 7/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView {
    
    var originalPosition: CGPoint!
    var dropTarget: UIView?
    
    var draggedItem = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
        draggedItem = currentItem
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.location(in: self.superview?.superview)
            
            let data:[String: Int] = ["item": draggedItem]
            
            if target.frame.contains(position){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil, userInfo: data)
            }
        }
        
        self.center = originalPosition
    }
    
}
