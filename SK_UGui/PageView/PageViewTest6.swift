//
//  PageViewTest6.swift
//  UGui
//      UITextViewのテストページ
//  Created by Shusuke Unno on 2017/07/17.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import Foundation
import UIKit

public class PageViewTest6 : UPageView {
    /**
     * Enums
     */
    /**
     * Constants
     */
    public static let TAG = "PageViewTest6"
    
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
    public override init( topScene : TopScene, title : String) {
        super.init( topScene: topScene, title: title)
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

        // 基準のラインを配置
        let line = SKNodeUtil.createLineNode(
            p1: CGPoint(x: scene.size.width / 2, y: 0),
            p2: CGPoint(x: scene.size.width / 2, y: scene.size.height),
            color: .red, lineWidth: 2.0)
        scene.addChild(line)
        
        let x : CGFloat = scene.size.width / 2
        var y : CGFloat = UUtil.navigationBarHeight() + PageViewTest1.MARGIN
        let buttonH : CGFloat = 50.0
     
        // None
        addTextView(x: x, y: y, alignment: .None, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN

        // CenterX
        addTextView(x: x, y: y, alignment: .CenterX, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN
        
        // CenterY
        addTextView(x: x, y: y, alignment: .CenterY, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN
        
        // Center
        addTextView(x: x, y: y, alignment: .Center, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN
        
        // Left
        addTextView(x: x, y: y, alignment: .Left, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN
        
        // Right
        addTextView(x: x, y: y, alignment: .Right, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN
        
        // Right_CenterY
        addTextView(x: x, y: y, alignment: .Right_CenterY, isMargin: true)
        y += buttonH + PageViewTest1.MARGIN
    }
    
    /**
     TextViewを１つ追加する
     */
    private func addTextView(x: CGFloat, y: CGFloat, alignment : UAlignment, isMargin : Bool)
    {
        let scene = TopScene.getInstance()
        
        let point = SKNodeUtil.createCrossPoint(pos: CGPoint(x:x, y:y), length: 10.0, lineWidth: 2.0, color: .yellow)
        scene.addChild(point)
        
        let text = UTextView(text: "hello world", textSize: 20, priority: 100, alignment: alignment, createNode: true, multiLine: false,
                              isDrawBG: true, isMargin: isMargin,
                              x: x, y: y, width: 0, color: .white, bgColor: .gray)
        text.parentNode.zPosition = 10.0
        scene.addChild2( text.parentNode )
        text.addToDrawManager()
    }
    
    // ダイアログを表示する
    func showDialog() {
        let dialog = UPopupWindow(topScene: mTopScene, popupType: UPopupType.OKCancel,
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
    
}
