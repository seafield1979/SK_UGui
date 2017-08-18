//
//  ULogWindow.swift
//  UGui
//
//  Created by Shusuke Unno on 2017/07/08.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import SpriteKit


public enum LogWindowType : Int {
    case Movable            // ドラッグで移動可能(クリックで表示切り替え)
    case Fix                // 固定位置に表示(ドラッグ移動不可、クリックで非表示にならない)
    case AutoDisappear      // ログが追加されてから一定時間で消える
}

/**
 * メッセージを表示するWindow
 * メッセージをリストで保持する
 * 古いメッセージが一定時間で削除される
 *
 */
public class ULogWindow : UWindow {
    public static let SHOW_TIME : TimeInterval = 3.0
    public static let DRAW_PRIORITY : Int = 5
    private static let TEXT_SIZE : Int = 14
    private static let MARGIN : Int = 10
    
    private var logs : List<LogData> = List()
    private var timer : Timer? = nil
    private var type : LogWindowType = LogWindowType.Fix
    private var count : Int = 1
    private var maxLog : Int = 0
    
    // SpriteKit Node
    private var labelNodes : [SKLabelNode] = []
    
    private init( parentView: TopScene,
                  x : CGFloat, y : CGFloat,
                  width : CGFloat, height : CGFloat,
                  color: UIColor)
    {
        super.init(parentView: parentView,
                   callbacks: nil, priority: ULogWindow.DRAW_PRIORITY,
                   createNode: true, cropping: true,
                   x: x, y: y, width: width, height: height,
                   bgColor: color, topBarH: 0, frameW: 0, frameH: 0)
        isShow = true
        if type == LogWindowType.AutoDisappear {
            startTimer(time: ULogWindow.SHOW_TIME)
        }
        let textSize = UDpi.toPixel(ULogWindow.TEXT_SIZE)
        maxLog = Int(height / textSize) + 1
        
        var y : CGFloat = 0
        for _ in 0..<maxLog {
            let n = SKNodeUtil.createLabelNode(text: "", textSize: textSize, color: .white, alignment: .Left, offset: CGPoint(x:10, y: y))
            labelNodes.append(n)
            clientNode.addChild(n)
            y += textSize
        }
    }
    
    /**
     * インスタンスを生成する
     * @param context
     * @param parentView
     * @param width
     * @param height
     * @return
     */
    public static func createInstance( parentView : TopScene,
                                       type : LogWindowType,
                                       x : CGFloat, y : CGFloat,
                                       width : CGFloat, height : CGFloat) -> ULogWindow
    {
        let instance = ULogWindow( parentView : parentView, x:x, y:y,
                                   width:width, height:height,
                                   color: UColor.makeColor(128,0,0,0))
        instance.parentView = parentView
        instance.type = type
        instance.initialize()
        return instance
    }
    
    private func initialize() {
        if type == LogWindowType.Fix {
            isShow = true
        }
        addCloseIcon(pos: CloseIconPos.RightTop)
        
        // 描画はDrawManagerに任せるのでDrawManagerに登録
        self.addToDrawManager()
    }
    
    public func addLog(_ text : String) {
        addLog(text, color: UIColor.white)
    }
    
    /**
     * メッセージを追加する
     * @param text
     * @param color
     */
    public func addLog(_ text : String, color : UIColor) {
        let msg = LogData(text: "" + count.description + ": " + text, color: color)
        
        // 追加先はリストの戦闘
        logs.push(msg)
        if logs.count > maxLog {
            _ = logs.removeLast()
        }
        
        if type == LogWindowType.AutoDisappear {
            startTimer(time: ULogWindow.SHOW_TIME )
        }
        count += 1
    }
    
    /**
     * ログをクリアする
     */
    public func clear() {
        logs.removeAll()
        count = 1
    }
    
    /**
     * 表示のON/OFFを切り替える
     */
    public func toggle() -> Bool {
        isShow = !isShow
        return isShow
    }
    
    /**
     * 毎フレーム行う処理
     *
     * @return true:描画を行う
     */
    override public func doAction() -> DoActionRet {
        // 自動移動
        if isMoving {
            if autoMoving() {
                return DoActionRet.Redraw
            }
        }
        return DoActionRet.None
    }
    
    /**
     * タッチアップイベント
     */
    override public func touchUpEvent(vt : ViewTouch) -> Bool {
        if vt.isTouchUp && closeIcon != nil {
            if closeIcon!.touchUpEvent(vt: vt) {
                return true
            }
        }
        return false
    }
    
    /**
     * タッチ処理
     * @param vt
     * @return trueならViewを再描画
     */
    public func touchEvent(vt : ViewTouch) -> Bool {
        return self.touchEvent(vt: vt, offset: nil)
    }
    
    override public func touchEvent(vt : ViewTouch, offset : CGPoint?) -> Bool {
        if (!isShow) {
            return false
        }
        if (super.touchEvent(vt: vt, offset: offset)) {
            return true
        }
        
        // 範囲外なら除外
        let point = CGPoint(x: vt.x, y: vt.y)
        if (!(rect!.contains(point))) {
            return false
        }
        
        switch vt.type {
        case .Click:
            if type != LogWindowType.Fix {
                isShow = false
            }
        case .Moving:
            if type == LogWindowType.Movable {
                if vt.isMoveStart {
                }
                pos.x += vt.moveX
                pos.y += vt.moveY
                updateRect()
            }
        default:
            break
        }
        
        if (super.touchEvent2(vt: vt, offset: offset)) {
            return true
        }
        
        return true
    }
    
    /**
     * ロングタッチ検出用のタイマーを開始
     */
    private func startTimer(time : TimeInterval) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: time, target: self,
                                     selector: #selector(self.timerFunc),
                                     userInfo: nil, repeats: false)
        
    }
    
    // タイマー処理
    @objc func timerFunc() {
        // 再描画
//        if parentView != nil {
//            parentView!.redraw = true
//        }
    }
    
    /*
     Drawableインターフェースのメソッド
     */
    /**
     * 描画処理
     * @param canvas
     * @param paint
     */
    override public func drawContent(offset : CGPoint?) {
        if !isShow {
            return
        }
        
        // テキスト表示
        drawText()
    }
    
    private func drawText() {
        // 全ログを表示
        var i = 0
        for msg in logs {
            labelNodes[i].text = msg!.text
            labelNodes[i].color = msg!.color
            i += 1
        }
    }
    
    /**
     * UButtonCallback
     */
    override public func UButtonClicked(id : Int, pressedOn : Bool) -> Bool {
        switch (id) {
        case ULogWindow.CloseButtonId:
            _ = toggle()
            return true
        default:
            break
        }
        return false
    }
}

/**
 * 表示メッセージ情報
 */
public struct LogData {
    var text : String
    var color : UIColor
}
