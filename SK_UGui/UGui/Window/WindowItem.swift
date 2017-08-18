//
//  WindowItem.swift
//  SK_UGui
//      UWindowのクライアント領域に表示するアイテム
//  Created by Shusuke Unno on 2017/08/14.
//  Copyright © 2017年 Sun Sun Soft. All rights reserved.
//

import SpriteKit

public class WindowItem {
    var name : String
    var pos : CGPoint
    var size : CGSize
    private var frame : CGRect {
        get {
            return CGRect(x: pos.x, y: pos.y, width: size.width, height: size.height)
        }
    }
    var node : SKShapeNode
    
    init(name: String, pos : CGPoint, size : CGSize) {
        self.name = name
        self.pos = pos
        self.size = size
        
        node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        node.name = name
        node.fillColor = .red
        node.strokeColor = .clear
        node.position = pos
        node.convPoint()
    }
}
