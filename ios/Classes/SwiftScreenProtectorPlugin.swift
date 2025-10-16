import Flutter
import UIKit
import ScreenProtectorKit

public class SwiftScreenProtectorPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel? = nil
    private var screenProtectorKitManager: ScreenProtectorKitManager? = nil
    
    init(_ screenProtectorKitManager: ScreenProtectorKitManager) {
        self.screenProtectorKitManager = screenProtectorKitManager
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftScreenProtectorPlugin.channel = FlutterMethodChannel(name: "screen_protector", binaryMessenger: registrar.messenger())
        
        let screenProtectorKitManager = ScreenProtectorKitManager()
        let instance = SwiftScreenProtectorPlugin(screenProtectorKitManager)
        registrar.addMethodCallDelegate(instance, channel: SwiftScreenProtectorPlugin.channel!)
        registrar.addApplicationDelegate(instance)
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Protect Data Leakage - ON && Prevent Screenshot - OFF
        screenProtectorKitManager?.applicationWillResignActive(application)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Protect Data Leakage - OFF && Prevent Screenshot - ON
        screenProtectorKitManager?.applicationDidBecomeActive(application)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>
        
        switch call.method {
        case "protectDataLeakageWithBlur":
            screenProtectorKitManager?.enableProtectionMode(.blur)
            result(true)
            break
        case "protectDataLeakageWithBlurOff":
            screenProtectorKitManager?.disableProtectionMode(.blur)
            result(true)
            break
        case "protectDataLeakageWithImage":
            screenProtectorKitManager?.enableProtectionMode(.image(name: args?["name"] ?? "LaunchImage"))
            result(true)
            break
        case "protectDataLeakageWithImageOff":
            screenProtectorKitManager?.disableProtectionMode(.image(name: ""))
            result(true)
            break
        case "protectDataLeakageWithColor":
            guard let hexColor = args!["hexColor"] else {
                result(false)
                return
            }
            result(screenProtectorKitManager?.enableProtectionMode(.color(hex: hexColor)) ?? false)
            break
        case "protectDataLeakageWithColorOff":
            _ = screenProtectorKitManager?.disableProtectionMode(.color(hex: ""))
            result(true)
            break
        case "protectDataLeakageOff":
            _ = screenProtectorKitManager?.disableAllProtection()
            result(true)
            break
        case "preventScreenshotOn":
            _ = screenProtectorKitManager?.enableScreenshotPrevention()
            result(true)
            break
        case "preventScreenshotOff":
            _ = screenProtectorKitManager?.disableScreenshotPrevention()
            result(true)
            break
        case "addListener":
            screenProtectorKitManager?.setListener(for: .screenshot) { _ in
                SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenshot", arguments: nil)
            }
            
            screenProtectorKitManager?.setListener(for: .screenRecording) { payload in
                if case let .screenRecording(isCaptured) = payload {
                    SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenRecord", arguments: isCaptured)
                }
            }
            
            result("listened")
            break
        case "removeListener":
            screenProtectorKitManager?.removeListeners()
            result("removed")
            break
        case "isRecording":
            result(screenProtectorKitManager?.isScreenRecording() ?? false)
            break
        default:
            result(false)
            break
        }
    }
    
    deinit {
        screenProtectorKitManager?.removeListeners()
    }
}
