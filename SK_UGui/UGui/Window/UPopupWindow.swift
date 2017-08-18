//
//  UPopupWindow.swift
//  UGui
//
//  Created by Shusuke Unno on 2017/07/08.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import SpriteKit

/**
 *
 * OKかキャンセルを押すまで消えないポップアップWindow
 */
// ポップアップウィンドウの種類
public enum UPopupType {
    case OK             // OKボタン1つだけ
    case OKCancel       // OK/Cancelの２つのbotann
}

public class UPopupWindow : UDialogWindow {
    
    /**
     * Constants
     */
    public static let OKButtonId = 10005000
    
    /**
     * Member variables
     */
    var titleNode : SKLabelNode
    
    /**
     * Constructor
     */
    public init( parentView : TopScene,
                  popupType : UPopupType,
                 title : String,
                 isAnimation : Bool,
                 screenW : CGFloat, screenH : CGFloat)
    {
        titleNode = SKNodeUtil.createLabelNode(text: title, textSize: 20, color: .black, alignment: .Center, offset: CGPoint(x:0, y:0))
        
        super.init( parentView: parentView,
                    type: DialogType.Mordal,
                    buttonCallbacks: nil,
                    dialogCallbacks: nil,
                    dir: ButtonDir.Horizontal, posType: DialogPosType.Center,
                    isAnimation: isAnimation,
                    x: 0, y: 0,
                    screenW: screenW, screenH: screenH,
                    textColor: UIColor.black, dialogColor: UColor.White)
        
        self.buttonCallbacks = self
        self.frameColor = UIColor.black
        self.title = title
        
        if popupType == UPopupType.OK {
            _ = addButton(id: UPopupWindow.OKButtonId, text: "OK",
                      textColor: UIColor.black,
                      color: UIColor.lightGray)
        } else {
            _ = addButton(id: UPopupWindow.OKButtonId, text: "OK",
                      textColor: UIColor.black,
                      color: UIColor.lightGray)
            addCloseButton(text: UResourceManager.getStringByName("cancel"))
        }
        updateLayout()
    }
    
    /**
     * UButtonCallbacks
     */
    public override func UButtonClicked(id : Int, pressedOn : Bool) -> Bool {
        
        switch(id) {
        case UPopupWindow.OKButtonId:
            startClosing()
            return true
        default:
            _ = super.UButtonClicked(id: id, pressedOn: pressedOn)
        }
        return false
    }
}
