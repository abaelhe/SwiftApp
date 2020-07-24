//
//  AppDelegate.swift
//  SinglePhoto
//
//  Created by Abael He on 7/9/20.
//  Copyright © 2020 Abael He. All rights reserved.
//


import UIKit
import HealthKit
import os
var CMDLINE = CommandLine.arguments.joined(separator: ", ")

// UIApplication是關聯到App自身的Singleton類(一個app僅有一個UIApplication實例)；是控制和調整app的中心點；
/*AppDelegate是App用來管理其對外Event事件的Delegate對象;
這三個applicaton(arg0, arg1)函數是通過不同參數類型和列表，來分別進行調用的；
arg0:是當前UIApplication實例；
arg1:設置
*/
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//UIResponder協議:接受和處理Events的抽象接口.
/*Events類型:
    1.touch: .touchesBegan(_:with:) | .touchesMoved(_:with:) | .touchesEnded(_:with:) | .touchesCancelled(_:with:)
     
    2.press:
    3.motion:
    4.remote-control:
    5.other.
*/
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

