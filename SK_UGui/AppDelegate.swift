//
//  AppDelegate.swift
//  SK_UGui
//
//  Created by Shusuke Unno on 2017/08/10.
//  Copyright © 2017年 Sun Sun Soft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    @IBOutlet var viewController: GameViewController?
    
    public static var rootViewController : UIViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        AppDelegate.rootViewController = window?.rootViewController
        
        // システム初期化
        initSystem()
        
        return true
    }
    func initSystem() {
        NanoTimer.initialize()
        ULog.initialize()
    }
}

