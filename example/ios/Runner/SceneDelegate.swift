//
//  SceneDelegate.swift
//  Runner
//
//  Created by INTENIQUETIC on 16/10/2568 BE.
//

import UIKit
import Flutter

class SceneDelegate: FlutterSceneDelegate {
    let flutterEngine = FlutterEngine(name: "my_engine")

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        self.registerSceneLifeCycle(with: flutterEngine)

        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = flutterViewController
        self.window = window
        window.makeKeyAndVisible()

        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    override func sceneDidEnterBackground(_ scene: UIScene) {
        let application = UIApplication.shared
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        bgTask = application.beginBackgroundTask {
            application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        }
        super.sceneDidEnterBackground(scene)
    }
}

