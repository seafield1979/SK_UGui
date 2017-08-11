//
//  SKNodeUtil.swift
//  SK_UGui
//    SpriteKitのノード関連の便利機能クラス
//  Created by Shusuke Unno on 2017/08/11.
//  Copyright © 2017年 Sun Sun Soft. All rights reserved.
//

import SpriteKit

public class SKNodeUtil {
    
    /**
     三角形のShapeNodeを作成する
     */
    public static func createTriangleNode(length : CGFloat, angle: CGFloat, color : SKColor) -> SKShapeNode {
        // 始点から終点までの４点を指定
        let rad = CGFloat.pi / 180
        var points = [CGPoint(x:cos((-30 + angle) * rad) * length,
                              y: sin((-30 + angle) * rad) * length),
                      CGPoint(x:cos((90 + angle) * rad) * length,
                              y: sin((90 + angle) * rad) * length),
                      CGPoint(x: cos((210 + angle) * rad) * length,
                              y: sin((210 + angle) * rad) * length),
                      CGPoint(x: cos((-30 + angle) * rad) * length,
                              y: sin((-30 + angle) * rad) * length)]
        let node = SKShapeNode(points: &points, count: points.count)
        node.fillColor = color
        node.strokeColor = .clear
        return node
    }
}
