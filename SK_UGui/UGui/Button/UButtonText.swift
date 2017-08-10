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
    private var parentNode : SKNode
    private var labelNode : SKLabelNode
    private var bgNode : SKShapeNode
    private var bg2Node : SKShapeNode
    
    private var mText : String?
    private var mTextColor : UIColor
    private var mTextSize : Int = 0
    private var mImage : UIImage? = nil
    private var mImageAlignment : UAlignment = UAlignment.Left     // 画像の表示位置
    private var mTextOffset : CGPoint? = CGPoint()
    private var mImageOffset : CGPoint? = CGPoint()
    private var mImageSize : CGSize? = CGSize()
    
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
    
    public func setImage(imageName : ImageName, imageSize : CGSize?) {
        mImage = UResourceManager.getImageByName(imageName)
        mImageSize = imageSize
    }
    
    public func setImage(image : UIImage?, imageSize : CGSize?) {
        mImage = image
        mImageSize = imageSize
    }
    
    public func setImageAlignment(alignment : UAlignment) {
        mImageAlignment = alignment
    }
    
    public func setTextOffset(x : CGFloat, y : CGFloat) {
        mTextOffset = CGPoint(x: x, y: y)
    }
    
    public func setImageOffset(x : CGFloat, y : CGFloat) {
        mImageOffset = CGPoint(x:x, y:y)
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
        
        // シーン
        let scene = TopScene.getInstance()
        
        // ノードを作成
        // parent
        self.parentNode = SKNode()
        self.parentNode.zPosition = CGFloat(priority)
        self.parentNode.position = scene.convertPoint(fromView: CGPoint(x:x, y:y))
        
        // BG
        self.bgNode = SKShapeNode(rect: CGRect(x:0, y:0, width: width, height: height))
        self.bgNode.fillColor = color!
        self.parentNode.addChild(self.bgNode)
        
        self.bg2Node = SKShapeNode(rect: CGRect(x:0, y:0, width: width, height: height))
        self.bg2Node.fillColor = color!
        self.parentNode.addChild(self.bg2Node)
        
        // Label
        self.labelNode = SKLabelNode(text: text)
        self.labelNode.fontColor = textColor
        self.labelNode.fontSize = CGFloat(textSize)
        self.labelNode.fontName = "HiraKakuProN-W6"
        self.labelNode.horizontalAlignmentMode = .center
        self.labelNode.verticalAlignmentMode = .center
        // SpriteKit座標系に変換する
        self.labelNode.position = CGPoint(x: width / 2, y: height / 2)
        parentNode.addChild(self.labelNode)
        
        scene.addChild(self.parentNode)

        
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
        
            }

    /**
     * Methods
     */
    public override func setChecked(_ checked : Bool) {
        super.setChecked(checked)
        
        // ボタンの左側にチェックアイコンを表示
        if checked {
            setImage(imageName: ImageName.ume,
                     imageSize: CGSize(width: UDpi.toPixel(UButtonText.CHECKED_W), height: UDpi.toPixel(UButtonText.CHECKED_W)))
        } else {
            setImage(image: nil, imageSize: nil)
        }
    }
    
    
    /**
      タッチ処理
     */
    public override func touchEvent(vt : ViewTouch, offset : CGPoint?) -> Bool {
        if (!enabled) {
            return false
        }
        
        let done = super.touchEvent(vt: vt, offset: offset)
        
        if isPressed {
            self.labelNode.fontColor = pressedColor
        } else {
            self.labelNode.fontColor = mTextColor
        }
        
        return done
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
        
        var _pos = CGPoint(x: pos.x, y: pos.y)
        if offset != nil {
            _pos.x += offset!.x
            _pos.y += offset!.y
        }
        
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
            var _pressedColor = pressedColor
            // 押したら凹むボタン
            if !enabled {
                _color = disabledColor
                _pressedColor = disabledColor2
            }
            if isPressed || pressedOn {
                _pos.y += UDpi.toPixel( UButton.PRESS_Y)
            } else {
                // ボタンの影用に下に矩形を描画
                let height : CGFloat = UDpi.toPixel( UButton.PRESS_Y + 13)
                
                UDraw.drawRoundRectFill(rect:
                    CGRect(x:_pos.x, y:_pos.y + size.height - height,
                           width: size.width,
                           height: height),
                        cornerR: UDpi.toPixel(UButton.BUTTON_RADIUS),
                        color:_pressedColor, strokeWidth: 0, strokeColor: nil)
            }
            _height -= UDpi.toPixel(UButton.PRESS_Y)
            
        }
        UDraw.drawRoundRectFill(rect: CGRect(x:_pos.x, y: _pos.y, width: size.width, height: _height),
                                cornerR: UDpi.toPixel(UButton.BUTTON_RADIUS), color: _color!, strokeWidth: 0, strokeColor: nil);
        
        // 画像
        if mImage != nil {
            var baseX : CGFloat = 0, baseY : CGFloat = 0
            
            switch mImageAlignment {
            case .None:
                baseX = 0
                baseY = (size.height - mImageSize!.height) / 2
                break
            case .CenterX:
                break
            case .CenterY:
                break
            case .Center:
                baseX = (size.width - mImageSize!.width) / 2
                baseY = (size.height - mImageSize!.height) / 2
                break
            case .Left:
                baseX = 50
                baseY = (size.height - mImageSize!.height) / 2
                break
            case .Right:
                break
            case .Right_CenterY:
                break
            }
            
            var offset : CGPoint = CGPoint()
            if let _offset = mImageOffset {
                offset = _offset
            }
            
            UDraw.drawImage(image:mImage!,
                             x: _pos.x + offset.x + baseX,
                             y: _pos.y + offset.y + baseY,
                             width: mImageSize!.width, height: mImageSize!.height)
        }
        // テキスト
        if mText != nil {
            var y : CGFloat = _pos.y + size.height / 2
            var offset : CGPoint = CGPoint()
            if mTextOffset != nil {
                offset = mTextOffset!
            }
            y += offset.y
            
            if isPressButton() {
                y -= UDpi.toPixel(UButton.PRESS_Y) / 2
            }
            
            UDraw.drawText(text: mText!, alignment: UAlignment.Center,
                           textSize: mTextSize,
                           x: _pos.x + offset.x + size.width / 2,
                           y: y, color: mTextColor);
        }
        // プルダウン
        if (pullDownIcon) {
            UDraw.drawTriangleFill(center: CGPoint(x:_pos.x + size.width - UDpi.toPixel(13) , y: _pos.y + size.height / 2),
                                   radius: UDpi.toPixel(10),
                                   rotation: 180.0, color: UButtonText.PULL_DOWN_COLOR)
        }
    }
}
