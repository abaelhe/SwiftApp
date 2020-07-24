//
//  main.swift //這個調用UIApplicationMain的文件必須為main.swift
//  SinglePhoto
//
//  Created by Abael He on 7/17/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
#if targetEnvironment(macCatalyst)
import AppKit
#endif

class AppMain:UIApplication{
    let userName:String = NSUserName()
    let homeDir:String = NSHomeDirectoryForUser(NSUserName())!
    let tmpDir:String = NSTemporaryDirectory()
    let fileManager:FileManager = FileManager.default
    let processInfo:ProcessInfo = ProcessInfo.processInfo

    //intercept this app's all event here
    override func sendEvent(_ event: UIEvent) {
        print("App Event[type:\(event.type.rawValue), subtype:\(event.subtype.rawValue) count:\(event.allTouches?.count)]")
        super.sendEvent(event)
    }
}

//class類的String表示是"<PROJECT_NAME>.<CLASS_NAME>",例如:
// 項目SinglePhoto內AppMain類的String表示為: "SinglePhoto.AppMain"
//注意Class的String並非直接名字對應！
let AppString = NSStringFromClass(AppMain.self)
let DelegateString = NSStringFromClass(AppDelegate.self)

//print("App:\(type(of:AppMain.shared)) Delegate:\(type(of:AppMain.shared.delegate))")
let errno = UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    AppString,
    DelegateString
)
