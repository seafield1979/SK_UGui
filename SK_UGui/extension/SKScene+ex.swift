//
//  SKScene+ex.swift
//  SK_UGui
//
//  Created by Shusuke Unno on 2017/08/17.
//  Copyright © 2017年 Sun Sun Soft. All rights reserved.
//

import SpriteKit

extension SKScene {
    
    /**
     追加するノードの座標系をUIView -> SpriteKitに変換してから
     シーンに追加する
     */
    public func addChild2(_ node : SKNode) {
        node.position = self.convertPoint(fromView: node.position)
        self.addChild(node)
    }
}
