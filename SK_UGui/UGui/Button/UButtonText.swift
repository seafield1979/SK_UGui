//
//  UButtonText.swift
//  UGui
//
//  Created by Shusuke Unno on 2017/07/08.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/**
 * テキストを表示するボタン
 */
public class UButtonText : UButton {
    /**
     * Enums
     */
    
    /**
     * Consts
     */
    public static let TAG = "UButtonText"
    
    private static let MARGIN_V : Int = 10
    private static let CHECKED_W : Int = 23
    
    static let DEFAULT_TEXT_COLOR = UIColor.black
    static let PULL_DOWN_COLOR = UColor.DarkGray
    
    /**
     * Member Variables
     */
    // SpriteKitのノード
    private var parentNode : SKNode
    private var labelNode : SKLabelNode
    private var bgNode : SKShapeNode
    private var bg2Node : SKShapeNode? = nil
    private var imageNode : SKSpriteNode? = nil
    private var pullNode : SKShapeNode? = nil
    
    private var mText : String?
    private var mTextColor : UIColor
    private var mTextSize : Int = 0
    private var mImageAlignment : UAlignment = UAlignment.Left     // 画像の表示位置
    private var mImageOffset : CGPoint? = CGPoint()
    private var mImageSize : CGSize? = CGSize()
    private var pullDownIcon : Bool = false     // プルダウンのアイコン▼を表示
    
    /**
     * Get/Set
     */
    
    public func getmText() -> String?{
        return mText
    }
    
    public func setText(mText : String?) {
        self.mText = mText;
    }
    
    public func setTextColor(mTextColor : UIColor) {
        self.mTextColor = mTextColor
    }
    
    public func setImage(imageName : ImageName, imageSize : CGSize) {
        imageNode = SKSpriteNode(imageNamed: imageName.rawValue)
        if imageNode != nil {
            imageNode!.size = imageSize
            bgNode.addChild( imageNode! )
            imageNode!.position = CGPoint(x: 100.0, y: -20)
            
            mImageSize = imageSize
            calcImageOffset(alignment: mImageAlignment)
        }
    }
    
    public func setImage(image : UIImage, imageSize : CGSize) {
        let texture = SKTexture(cgImage: image.cgImage!)
        imageNode = SKSpriteNode(texture: texture)
        imageNode!.size = imageSize
        mImageSize = imageSize
        
        calcImageOffset(alignment: mImageAlignment)
    }
    
    // 画像の表示座標を計算する
    private func calcImageOffset( alignment : UAlignment) {
        var baseX : CGFloat = 0, baseY : CGFloat = 0
        
        switch mImageAlignment {
        case .None:
            baseX = 0
            baseY = bgNode.frame.size.height / 2
            break
        case .CenterX:
            break
        case .CenterY:
            break
        case .Center:
            baseX = bgNode.frame.size.width / 2
            baseY = bgNode.frame.size.height / 2
            break
        case .Left:
            baseX = 50
            baseY = bgNode.frame.size.height / 2
            break
        case .Right:
            break
        case .Right_CenterY:
            break
        }
        
        var offset = CGPoint()
        if mImageOffset != nil {
            offset = mImageOffset!
        }
        
        imageNode!.position = CGPoint(x: baseX + offset.x,
                                      y: SKUtil.convY(fromView: baseY + offset.y))

    }
    
    public func setImageAlignment(alignment : UAlignment) {
        mImageAlignment = alignment
    }
    
    public func setTextOffset(x : CGFloat, y : CGFloat) {
        labelNode.position = CGPoint(x: x, y: SKUtil.convY(fromView: y))
    }
    
    public func setImageOffset(x : CGFloat, y : CGFloat) {
        mImageOffset = CGPoint(x: x, y: y)
    }
    
    /**
     * Constructor
     */
    init(callbacks : UButtonCallbacks?, type : UButtonType, id : Int,
                     priority : Int, text : String,
                     x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat,
                     textSize : Int, textColor : UIColor?, color : UIColor?)
    {
        self.mText = text
        self.mTextColor = textColor!
        self.mTextSize = textSize
        
        let w = width
        let h = height
        
        // シーン
        let scene = TopScene.getInstance()
        
        // ノードを作成
        // parent
        self.parentNode = SKNode()
        self.parentNode.zPosition = CGFloat(priority)
        self.parentNode.position = scene.convertPoint(fromView: CGPoint(x:x, y:y))
        scene.addChild(parentNode)
        
        // BG
        let bgH = (type == .BGColor) ? h : (h - UDpi.toPixel(UButton.PRESS_Y))
            
        self.bgNode = SKShapeNode(rect: CGRect(x:0, y:0, width: w, height: bgH).convToSK(),
                                  cornerRadius: 10.0)
        self.bgNode.fillColor = color!
        self.bgNode.strokeColor = .clear
        self.bgNode.zPosition = 0.1
        self.parentNode.addChild(self.bgNode)
        
        // Label
        self.labelNode = SKLabelNode(text: text)
        self.labelNode.fontColor = textColor
        self.labelNode.fontSize = CGFloat(textSize)
        self.labelNode.fontName = "HiraKakuProN-W6"
        self.labelNode.horizontalAlignmentMode = .center
        self.labelNode.verticalAlignmentMode = .center
        self.labelNode.position = CGPoint(x: w / 2, y: bgH / 2).convToSK()
        self.bgNode.addChild(self.labelNode)
        

        super.init(callbacks: callbacks, type: type, id: id, priority: priority,
                   x: x, y: y, width: width, height: height, color: color)
        
        var textColor = textColor   // 引数はletなのでvarで再定義
        if textColor == nil {
            textColor = UButtonText.DEFAULT_TEXT_COLOR
        }
        
        if height == 0 {
            let size = UDraw.getTextSize(text: text, textSize: textSize)
            setSize(width, size.height + UDpi.toPixel( UButtonText.MARGIN_V) * 2)
        }
        
        // BG2(影の部分)
        if type != .BGColor {
            let _h = UDpi.toPixel( UButton.PRESS_Y + 20)
            self.bg2Node = SKShapeNode(rect: CGRect(x:0, y:bgH - UDpi.toPixel(20), width: w, height: _h).convToSK(),
                                       cornerRadius: 10.0)
            self.bg2Node!.fillColor = pressedColor
                self.bg2Node!.strokeColor = .clear
            self.parentNode.addChild(self.bg2Node!)
        }
    }

    /**
     * Methods
     */
    public override func setChecked(_ checked : Bool) {
        super.setChecked(checked)
        
        // ボタンの左側にチェックアイコンを表示
        if checked {
            if imageNode == nil {
                setImage(imageName: ImageName.ume,
                         imageSize: CGSize(width: UDpi.toPixel(UButtonText.CHECKED_W), height: UDpi.toPixel(UButtonText.CHECKED_W)))
            }
        } else {
            if imageNode != nil {
                imageNode!.removeFromParent()
            }
        }
    }
    
    public func setPullDownIcon(_ pullDown : Bool) {
        if pullNode == nil {
            pullNode = SKNodeUtil.createTriangleNode(
                length: UDpi.toPixel(10),
                angle: 180,
                color: UButtonText.PULL_DOWN_COLOR)
            pullNode!.position = CGPoint(x: size.width - UDpi.toPixel(30), y: SKUtil.convY(fromView: size.height / 2))

            bgNode.addChild(pullNode!)
        }
    }
    
    
    /**
     * 描画処理
     * @param canvas
     * @param paint
     * @param offset 独自の座標系を持つオブジェクトをスクリーン座標系に変換するためのオフセット値
     */
    public override func draw(_ offset : CGPoint?) {
        // 色
        // 押されていたら明るくする
        var _color = color
        var _pos = CGPoint(x: 0, y: 0)
        var _height = size.height
        
        if type == UButtonType.BGColor {
            // 押したら色が変わるボタン
            if !enabled {
                _color = disabledColor
            }
            else if isPressed {
                _color = pressedColor
            }
        }
        else {
            // 押したら凹むボタン
            if !enabled {
                _color = disabledColor
            }
            if isPressed || pressedOn {
                _pos.y += UDpi.toPixel( UButton.PRESS_Y)
            }
            _height -= UDpi.toPixel(UButton.PRESS_Y)
            
        }
        self.bgNode.position = CGPoint(x: 0, y: SKUtil.convY(fromView: _pos.y))
        self.bgNode.fillColor = _color!
    }
}
