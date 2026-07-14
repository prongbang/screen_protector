//
//  FlutterRootViewResolver.swift
//  
//
//  Created by INTENIQUETIC on 18/1/2569 BE.
//

import Flutter
import UIKit
import ScreenProtectorKit

final class FlutterRootViewResolver: ScreenProtectorRootViewResolving {
    func resolveRootView() -> UIView? {
        guard Thread.isMainThread else {
            log("resolveFlutterRootView: called off main thread")
            return nil
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
            log("resolveFlutterRootView: no foreground active UIWindowScene")
            return nil
        }
        
        let keyWindow: UIWindow?
        if #available(iOS 15.0, *) {
            keyWindow = windowScene.keyWindow
        } else {
            keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
        }

        guard let flutterVC = keyWindow?
            .rootViewController as? FlutterViewController else {
            log("resolveFlutterRootView: FlutterViewController not found on key window")
            return nil
        }
        
        return flutterVC.view
    }
    
    private func log(_ message: String) {
        //print("[FlutterRootViewResolver]: \(message)")
    }
}
