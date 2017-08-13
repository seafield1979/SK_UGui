//
//  WindowItemNode.swift
//  SK_UGui
//    ScrollWindowに表示できるノード
//  Created by Shusuke Unno on 2017/08/13.
//  Copyright © 2017年 Sun Sun Soft. All rights reserved.
//

import SpriteKit

class WindowItemNode {
    
    var node : SKNode
    var basePos : CGPoint
    
    init(node : SKNode, pos : CGPoint) {
        self.node = node
        self.basePos = pos
    }
}
