//
//  ListItemTest1.swift
//  UGui
//
//  Created by Shusuke Unno on 2017/07/17.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import SpriteKit

public class ListItemTest1 : UListItem {
    /**
     * Constants
     */
    public static let ITEM_H = 50
    public static let TEXT_SIZE = 17
    
    // colors
    private static let TEXT_COLOR = UIColor.blue
    
    /**
     * Member variables
     */
    private var mText : String? = nil
    private var mTextSize : Int = 10
    
    // SpriteKit Node
    private var labelNode : SKLabelNode?
    
    /**
     * Constructor
     */
    public init(callbacks : UListItemCallbacks?,
                              text : String,
                              x : CGFloat, width : CGFloat, color : UIColor)
    {
        super.init(callbacks: callbacks,
                   isTouchable: true,
                   x: x, width: width, height: UDpi.toPixel(ListItemTest1.ITEM_H),
                   bgColor: color, frameW: 2, frameColor: UIColor.black)
        self.color = color
        mText = text
        mTextSize = Int(UDpi.toPixel(ListItemTest1.TEXT_SIZE))
        
        // SpriteKit Node
        // 親クラスでbgNodeは作成済み
        labelNode = SKNodeUtil.createLabelNode(text: text, fontSize: CGFloat(mTextSize), color: .white, alignment: .Center, pos: nil).node
        labelNode!.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bgNode.addChild(labelNode!)
    }
    
    /**
     * Methods
     */
    
    /**
     * 描画処理
     * @param canvas
     * @param paint
     * @param offset 独自の座標系を持つオブジェクトをスクリーン座標系に変換するためのオフセット値
     */
    override public func draw() {
    }
    
    /**
     * このtouchEventは使用しない
     */
    public func touchEvent(vt : ViewTouch) -> Bool{
        return false
    }
    
    /**
     * 高さを返す
     */
    public func getHeight() -> Int{
        return ListItemTest1.ITEM_H
    }
}
