import Flutter
import UIKit
import ScreenProtectorKit

#if USE_SPM
public class ScreenProtectorPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftScreenProtectorPlugin.register(with: registrar)
    }
}
#endif

public class SwiftScreenProtectorPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel? = nil
    private var screenProtectorKitManager: ScreenProtectorKitManager?
    
    private func initializeManagerIfNeeded() {
        // Manager exists already → no need to re-init
        if screenProtectorKitManager != nil { return }

        let wm = WindowManager()
        guard let window = wm.getWindow() else {
            print("[Error] UIWindow is not found.")
            return
        }

        let kit = ScreenProtectorKit(window: window)
        self.screenProtectorKitManager = ScreenProtectorKitManager(screenProtectorKit: kit)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftScreenProtectorPlugin.channel = FlutterMethodChannel(name: "screen_protector", binaryMessenger: registrar.messenger())
        let instance = SwiftScreenProtectorPlugin()
        registrar.addMethodCallDelegate(instance, channel: SwiftScreenProtectorPlugin.channel!)
        registrar.addApplicationDelegate(instance)
        
        // Initialize manager safely on main thread
        DispatchQueue.main.async {
            instance.initializeManagerIfNeeded()
        }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Protect Data Leakage - ON && Prevent Screenshot - OFF
        DispatchQueue.main.async {
            self.initializeManagerIfNeeded()
            self.screenProtectorKitManager?.applicationWillResignActive(application)
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Protect Data Leakage - OFF && Prevent Screenshot - ON
        DispatchQueue.main.async {
            self.initializeManagerIfNeeded()
            self.screenProtectorKitManager?.applicationDidBecomeActive(application)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>
        DispatchQueue.main.async {
            switch call.method {
            case "protectDataLeakageWithBlur":
                self.screenProtectorKitManager?.enableProtectionMode(.blur)
                result(true)
                break
            case "protectDataLeakageWithBlurOff":
                self.screenProtectorKitManager?.disableProtectionMode(.blur)
                result(true)
                break
            case "protectDataLeakageWithImage":
                self.screenProtectorKitManager?.enableProtectionMode(.image(name: args?["name"] ?? "LaunchImage"))
                result(true)
                break
            case "protectDataLeakageWithImageOff":
                self.screenProtectorKitManager?.disableProtectionMode(.image(name: ""))
                result(true)
                break
            case "protectDataLeakageWithColor":
                guard let hexColor = args!["hexColor"] else {
                    result(false)
                    return
                }
                result(self.screenProtectorKitManager?.enableProtectionMode(.color(hex: hexColor)) ?? false)
                break
            case "protectDataLeakageWithColorOff":
                _ = self.screenProtectorKitManager?.disableProtectionMode(.color(hex: ""))
                result(true)
                break
            case "protectDataLeakageOff":
                _ = self.screenProtectorKitManager?.disableAllProtection()
                result(true)
                break
            case "preventScreenshotOn":
                _ = self.screenProtectorKitManager?.enableScreenshotPrevention()
                result(true)
                break
            case "preventScreenshotOff":
                _ = self.screenProtectorKitManager?.disableScreenshotPrevention()
                result(true)
                break
            case "addListener":
                self.screenProtectorKitManager?.setListener(for: .screenshot) { _ in
                    SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenshot", arguments: nil)
                }
                
                self.screenProtectorKitManager?.setListener(for: .screenRecording) { payload in
                    if case let .screenRecording(isCaptured) = payload {
                        SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenRecord", arguments: isCaptured)
                    }
                }
                
                result("listened")
                break
            case "removeListener":
                self.screenProtectorKitManager?.removeListeners()
                result("removed")
                break
            case "isRecording":
                result(self.screenProtectorKitManager?.isScreenRecording() ?? false)
                break
            default:
                result(false)
                break
            }
        }
    }
    
    deinit {
        screenProtectorKitManager?.removeListeners()
    }
}
