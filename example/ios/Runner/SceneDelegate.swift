//
//  SceneDelegate.swift
//  Runner
//
//  Created by INTENIQUETIC on 16/10/2568 BE.
//

import UIKit
import Flutter

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let flutterEngine = appDelegate.flutterEngine else { return }
        
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = flutterViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

