//
//  UMenuItem.swift
//  UGui
//
//  メニューに表示する項目
//  アイコンを表示してタップされたらIDを返すぐらいの機能しか持たない
//  Created by Shusuke Unno on 2017/07/08.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import SpriteKit

public protocol UMenuItemCallbacks {
    // メニューの項目がクリックされたときのコールバック
    func menuItemClicked(itemId : Int, stateId : Int)
}


public class UMenuItem : UDrawable {
    public static let TAG = "UMenuItem"
    
    public static let DRAW_PRIORITY = 200
    public static let TOP_ITEM_W = 50
    public static let ITEM_W = 40
    
    private static let CHILD_MARGIN_V = 10
    private static let CHILD_MARGIN_H = 10
    private static let TEXT_SIZE = 13
    
    /**
     * メンバ変数
     */
    var mMenuBar : UMenuBar
    var mCallbacks : UMenuItemCallbacks? = nil
    var mTextTitle : UTextView? = nil
    var mItemId : Int = 0
    var mNestCount : Int = 0
    var mStateId : Int = 0          // 現在の状態
    var mStateMax : Int = 0         // 状態の最大値 addState で増える
    var mShowTitle : Bool = false
    
    
    // SpriteKit Node
    var parentNode : SKNode
    var spriteNode : SKSpriteNode?
//    var textNode : SKLabelNode?
//    var textBGNode : SKShapeNode?
    
    // 親アイテム
    var mParentItem : UMenuItem? = nil
    // 子アイテムリスト
    var mChildItem : List<UMenuItem>? = nil
    
    // 開いた状態、子アイテムを表示中かどうか
    var isOpened : Bool = false
    
    // アイコン用画像
    var icons : List<SKTexture> = List()
    
    // 閉じている移動中かどうか
    var isClosing : Bool = false
    
    
    /**
     イニシャライザ
     */
    public init( menuBar: UMenuBar, parentItem : UMenuItem?, id: Int, isTop : Bool, icon : UIImage?) {
        
        let width = isTop ? UDpi.toPixel(UMenuItem.TOP_ITEM_W) : UDpi.toPixel(UMenuItem.ITEM_W)
        let height = UDpi.toPixel(isTop ? UMenuItem.TOP_ITEM_W : UMenuItem.ITEM_W)
        
        self.mMenuBar = menuBar
        self.mTextTitle = nil
        
        // SpriteKit Node
        parentNode = SKNode()
        if parentItem != nil {
            parentItem!.parentNode.addChild( parentNode )
        } else {
            menuBar.parentNode.addChild(parentNode)
        }
        
        super.init(priority: UMenuItem.DRAW_PRIORITY, x: 0, y: 0,
                    width: width,
                    height: height)
        self.mItemId = id
        self.mStateId = 0
        self.mStateMax = 1
        self.animeFrame = 0
        self.animeFrameMax = 10
        if icon != nil {
            let texture = SKTexture(image: icon!)
            icons.append(texture)
            spriteNode = SKSpriteNode(texture: texture)
            spriteNode!.size = size
            spriteNode!.anchorPoint = CGPoint(x:0, y:1)
            parentNode.addChild(spriteNode!)
        }
    }
    
    public func setmParentItem(mParentItem : UMenuItem) {
        self.mParentItem = mParentItem
    }
    
    /**
     * テキストを追加する
     */
    public func addTitle(title : String, alignment : UAlignment,
                         x : CGFloat, y : CGFloat,
                         color : UIColor, bgColor : UIColor? )
    {
        mTextTitle = UTextView.createInstance(
            text: title,
            textSize: UMenuItem.TEXT_SIZE, priority: 0, alignment: alignment,
            multiLine: false, isDrawBG: true,
            x: x, y: y, width: 0, color: color, bgColor: bgColor)
        
        mShowTitle = true
        mTextTitle?.setMargin( 15, 15)
        
        parentNode.addChild(mTextTitle!.parentNode)
    }
    
    /**
     * 子要素を追加する
     * @param child
     */
    public func addItem(child : UMenuItem) {
        if mChildItem == nil {
            mChildItem = List()
        }
        // 親を設定する
        mParentItem =  self
        child.mNestCount += 1
        
        mChildItem!.append(child)
    }
    
    /**
     * 状態を追加する
     * @param icon 追加した状態の場合に表示するアイコン
     */
    public func addState(icon : UIImage) {
        let texture = SKTexture( image: icon)
        icons.append(texture)
        
        mStateMax += 1
    }
    
    /**
     * 次の状態にすすむ
     */
    public func setNextState() -> Int {
        if mStateMax >= 2 {
            mStateId = (mStateId + 1) % mStateMax;
        }
        return mStateId
    }
    
    private func getNextStateId() -> Int {
        if mStateMax >= 2 {
            return (mStateId + 1) % mStateMax
        }
        return 0
    }
    
    /**
     * 描画処理
     * @param canvas
     * @param paint
     * @param parentPos
     */
    override public func draw(_ parentPos: CGPoint) {
        spriteNode!.isHidden = !isShow
        if !isShow {
            return
        }
        
        if icons.count > 0 {
            // 次の状態のアイコンを表示する
            let texture = icons[getNextStateId()]
            
            // アニメーション処理
            // フラッシュする
            var alpha : CGFloat = 1.0
            if isAnimating {
                alpha = getAnimeAlpha()
            } else if isMoving {
                alpha = CGFloat(movingFrame) / CGFloat(movingFrameMax)
                if isClosing {
                    alpha = 1.0 - alpha
                }
            }
            
            spriteNode!.texture = texture
            spriteNode!.alpha = alpha
            spriteNode!.blendMode = .alpha
            parentNode.position = CGPoint(x: pos.x, y: pos.y).convToSK()
        
            // 領域の幅に合わせて伸縮
//            icon.draw(in: CGRect(x:drawPos.x, y:drawPos.y,
//                                 width: size.width, height: size.width),
//                      blendMode: CGBlendMode.sourceAtop, alpha: alpha)
            // タイトル
//            if !isMoving && !isClosing {
//                mTextTitle?.draw(drawPos)
//            }
        }
        
        // 子要素
        if mChildItem != nil {
            for item in mChildItem! {
                item!.draw(parentPos)
            }
        }
    }
    
    /**
     * アニメーション開始
     */
    public func startAnim() {
        mMenuBar.isAnimating = true
        isAnimating = true
        animeFrame = 0
    }
    
    /**
     * アニメーション処理
     * といいつつフレームのカウンタを増やしているだけ
     * @return true:アニメーション中
     */
    public override func animate() -> Bool {
        if !isAnimating {
            return false
        }
        if animeFrame >= animeFrameMax {
            isAnimating = false
            return false
        }
        animeFrame += 1
        return true
    }
    
    /**
     * タッチイベント
     * MenuBarクラスで処理するのでここでは何もしない
     * @param vt
     * @return
     */
    public func touchEvent(vt : ViewTouch, offset : CGPoint) -> Bool {
        return false
    }
    
    /**
     * クリック処理
     * @param touchX
     * @param touchY
     * @return
     */
    public func checkTouch(vt: ViewTouch ,
                           touchX: CGFloat, touchY: CGFloat) -> Bool
    {
        if (vt.checkInsideCircle(
            vx: touchX, vy:touchY,
            x: pos.x + UDpi.toPixel(UMenuItem.ITEM_W) / 2,
            y: pos.y + UDpi.toPixel(UMenuItem.ITEM_W) / 2,
            length: UDpi.toPixel(UMenuItem.ITEM_W) / 2))
        {
            if vt.type != TouchType.Touch {
                return false
            }
        
            // 子要素を持っていたら Open/Close
            if mChildItem != nil {
                if isOpened {
                    isOpened = false
                    closeMenu()
                } else {
                    isOpened = true
                    openMenu()
                }
                ULog.printMsg(UMenuItem.TAG, "isOpened " + isOpened.description)
            } else {
                // タッチされた時の処理
                _ = setNextState()
            
                if mCallbacks != nil {
                    mCallbacks!.menuItemClicked(itemId: mItemId, stateId: mStateId)
                }
            }
            // アニメーション
            startAnim()
            
            return true
        }
    
        // 子要素
        if isOpened && mChildItem != nil {
            for child in mChildItem! {
                // この座標系(親原点)に変換
                if (child!.checkTouch(vt: vt,
                                     touchX: touchX - pos.x,
                                     touchY: touchY - pos.y))
                {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     * メニューをOpenしたときの処理
     */
    public func openMenu() {
        if mChildItem == nil {
            return
        }
        
        isOpened = true
        
        var count = 1
        
        for item in mChildItem! {
            item!.setPos(0, 0)
            
            // 親の階層により開く方向が変わる
            item!.isClosing = false
            item!.isShow = true
            
            // 縦方向
            item!.startMoving(
                dstX: 0,
                dstY: CGFloat(-count) * UDpi.toPixel(UMenuItem.ITEM_W + UMenuItem.CHILD_MARGIN_V),
                frame: animeFrameMax )
            
            count += 1
        }
    }
    
    /**
     * メニューをCloseしたときの処理
     */
    public func closeMenu() {
        if mChildItem == nil {
            return
        }
    
        isOpened = false;
        
        for item in mChildItem! {
            item!.startMoving(dstX:0, dstY: 0, frame: animeFrameMax)
            item!.isClosing = true
            if item!.isOpened {
                item!.closeMenu()
            }
        }
    }
    
    /**
     * 毎フレームの処理
     * @return true:処理中(再描画あり)
     */
    override public func doAction() -> DoActionRet {
        var ret = DoActionRet.None
        
        // 自分の処理
        // 移動
        if autoMoving() {
            ret = DoActionRet.Redraw
        } else if (isClosing) {
            isShow = false
        }
        
        // アニメーション
        if animate() {
            ret = DoActionRet.Redraw
        }
        
        // 子要素のdoAction
        if mChildItem != nil {
            for item in mChildItem! {
                let _ret = item!.doAction()
                switch (_ret) {
                case .Done:
                    return _ret
                case .Redraw:
                    ret = _ret
                default:
                    break
                }
            }
        }
        return ret
    }
    
    /**
     * Drawableインターフェース
     */
//    override public func getDrawOffset() -> CGPoint? {
//        return nil
//    }
}

