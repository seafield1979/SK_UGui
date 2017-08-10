//
//  UDebug.swift
//  UGui
//
//  Created by Shusuke Unno on 2017/07/08.
//  Copyright © 2017年 Shusuke Unno. All rights reserved.
//

import Foundation

public class UDebug {
    // Debug mode
    public static let isDebug : Bool = false
    
    // IconをまとめたブロックのRECTを描画するかどうか
    public static let DRAW_ICON_BLOCK_RECT : Bool = false
    
    public static let drawIconId : Bool = false
    
    // UDrawableオブジェクトの描画範囲をライン描画
    public static let drawRectLine : Bool = false
    
    // Select時にログを出力
    public static let debugDAO : Bool = false
    
    // テキストのベース座標に+を描画
    public static let drawTextBaseLine : Bool = false
    
    
    /**
     * Methods
     */
    /**
     * システムの全データクリア
     * アプリインストールと同じ状態に戻る
     */
    public static func clearSystemData() {
        // MySharedPref
        // todo
//        MySharedPref.clearAllData()
//        
//        // Realm
//        // データベースを削除
//        RealmManager.clearAll()
//        
//        // セーブデータを初期化
//        RealmManager.getBackupFileDao().createInitialRecords()
//        // デフォルト単語帳を追加
//        PresetBookManager.getInstance().addDefaultBooks()
//        
//        MySharedPref.getInstance().writeBoolean(MySharedPref.InitializeKey, true)
    }
}
