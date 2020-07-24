//
//  SceneDelegate.swift
//  SinglePhoto
//
//  Created by Abael He on 7/10/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


/*将LandmarkList作为root view根视图;
 App启动后以Scene Delegate设定的root view作为首页展示;
(在模拟器Simulator而不是Preview模式时)
 */
class SceneDelegate:UIResponder, UIWindowSceneDelegate{
    var window: UIWindow?
    
    func scene(_ scene:UIScene, willConnectTo session:UISceneSession, options connectionOptions:UIScene.ConnectionOptions){
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene{
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: LandmarkList().environmentObject(UserData()))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    // ...
}
