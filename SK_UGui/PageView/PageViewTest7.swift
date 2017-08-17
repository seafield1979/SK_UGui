//
//  PageViewTest7.swift
//  SK_UGui
//
//  Created by Shusuke Unno on 2017/08/12.
//  Copyright © 2017年 Sun Sun Soft. All rights reserved.
//

import Foundation
import UIKit

public class PageViewTest7 : UPageView, UWindowCallbacks {
    /**
     * Enums
     */
    /**
     * Constants
     */
    public static let TAG = "PageViewTest7"
    
    public static let buttonId1 = 100
    public static let buttonId2 = 101
    public static let buttonId3 = 102
    public static let buttonId4 = 103
    
    /**
     * Propaties
     */
    
    /**
     * Constructor
     */
    public override init( topView : TopScene, title : String) {
        super.init( topView: topView, title: title)
    }
    
    /**
     * Methods
     */
    
    override func onShow() {
    }
    
    override func onHide() {
        super.onHide();
    }
    
    /**
     * 描画処理
     * サブクラスのdrawでこのメソッドを最初に呼び出す
     * @param canvas
     * @param paint
     * @return
     */
    override func draw() -> Bool {
        if isFirst {
            isFirst = false
            initDrawables()
        }
        return false
    }
    
    /**
     * タッチ処理
     * @param vt
     * @return
     */
    public func touchEvent(vt : ViewTouch) -> Bool {
        
        return false
    }
    
    /**
     * そのページで表示される描画オブジェクトを初期化する
     */
    override public func initDrawables() {
        UDrawManager.getInstance().initialize()
        
        let scene = TopScene.getInstance()
        
        let window = UScrollWindow(parentView: scene, callbacks: self, priority: 100, x: 50, y: 50, width: 200, height: 200,
                                   color: .white, topBarH: 10, frameW: 3, frameH: 3)
        
        window.setContentSize(width: 1000, height: 1000, update: true)
        window.addToDrawManager()
        
        // アイテムを追加
        for i in 0..<10 {
            window.addItem(name: "item \(i+1)", pos: CGPoint(x: CGFloat(i) * 100.0, y: CGFloat(i) * 100.0), size: CGSize(width: 50, height: 50))
        }
    }
    
    /**
     TextViewを１つ追加する
     */
    private func addTextView(x: CGFloat, y: CGFloat, alignment : UAlignment, isMargin : Bool)
    {
        let scene = TopScene.getInstance()
        
        let point = SKNodeUtil.createCrossPoint(pos: CGPoint(x:x, y:y), length: 10.0, lineWidth: 2.0, color: .yellow)
        scene.addChild(point)
        
        let text = UTextView(text: "hello world", textSize: 20, priority: 100, alignment: alignment, multiLine: false,
                             isDrawBG: true, isMargin: isMargin,
                             x: x, y: y, width: 0, color: .white, bgColor: .gray)
        text.parentNode.zPosition = 10.0
        text.addToDrawManager()
    }
    
    // ダイアログを表示する
    func showDialog() {
        let dialog = UPopupWindow(parentView: mTopView!, popupType: UPopupType.OKCancel,
                                  title: "hoge", isAnimation: true,
                                  screenW: CGFloat(UUtil.screenWidth()),
                                  screenH: CGFloat(UUtil.screenHeight()))
        dialog.addToDrawManager()
    }
    
    /**
     * ソフトウェアキーの戻るボタンを押したときの処理
     * @return
     */
    public override func onBackKeyDown() -> Bool {
        return false
    }
    
    /**
     * Callbacks
     */
    
    // MARK : UWindowCallbacks
    public func windowClose(window : UWindow) {
        
    }
}
