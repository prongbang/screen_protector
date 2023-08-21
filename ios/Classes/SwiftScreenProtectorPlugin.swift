import Flutter
import UIKit
import ScreenProtectorKit

public class SwiftScreenProtectorPlugin: NSObject, FlutterPlugin {
    
    private static var channel: FlutterMethodChannel? = nil
    
    private var enabledPreventScreenshot: EnabledStatus = .idle
    private var enabledProtectDataLeakageWithBlur: EnabledStatus = .idle
    private var enabledProtectDataLeakageWithImage: EnabledStatus = .idle
    private var enabledProtectDataLeakageWithColor: EnabledStatus = .idle
    private var protectDataLeakageWithImageName: String = ""
    private var protectDataLeakageWithColor: String = ""
    
    private var screenProtectorKit: ScreenProtectorKit? = nil
    
    init(screenProtectorKit: ScreenProtectorKit) {
        self.screenProtectorKit = screenProtectorKit
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftScreenProtectorPlugin.channel = FlutterMethodChannel(name: "screen_protector", binaryMessenger: registrar.messenger())
        
        let window = UIApplication.shared.delegate?.window
        let screenProtectorKit = ScreenProtectorKit(window: window as? UIWindow)
        screenProtectorKit.configurePreventionScreenshot()
        
        let instance = SwiftScreenProtectorPlugin(screenProtectorKit: screenProtectorKit)
        registrar.addMethodCallDelegate(instance, channel: SwiftScreenProtectorPlugin.channel!)
        registrar.addApplicationDelegate(instance)
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Protect Data Leakage - ON
        if enabledProtectDataLeakageWithColor == .on {
            screenProtectorKit?.enabledColorScreen(hexColor: protectDataLeakageWithColor)
        } else if enabledProtectDataLeakageWithImage == .on {
            screenProtectorKit?.enabledImageScreen(named: protectDataLeakageWithImageName)
        } else if enabledProtectDataLeakageWithBlur == .on {
            screenProtectorKit?.enabledBlurScreen()
        }
        
        // Prevent Screenshot - OFF
        if enabledPreventScreenshot == .off {
            screenProtectorKit?.disablePreventScreenshot()
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Protect Data Leakage - OFF
        if enabledProtectDataLeakageWithColor == .on {
            screenProtectorKit?.disableColorScreen()
        } else if enabledProtectDataLeakageWithImage == .on {
            screenProtectorKit?.disableImageScreen()
        } else if enabledProtectDataLeakageWithBlur == .on {
            screenProtectorKit?.disableBlurScreen()
        }
        
        // Prevent Screenshot - ON
        if enabledPreventScreenshot == .on {
            screenProtectorKit?.enabledPreventScreenshot()
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>
        
        switch call.method {
        case "protectDataLeakageWithBlur":
            enabledProtectDataLeakageWithBlur = .on
            break
        case "protectDataLeakageWithBlurOff":
            enabledProtectDataLeakageWithBlur = .off
            break
        case "protectDataLeakageWithImage":
            if args != nil {
                protectDataLeakageWithImageName = args!["name"] ?? "LaunchImage"
            }
            enabledProtectDataLeakageWithImage = .on
            break
        case "protectDataLeakageWithColor":
            if args != nil {
                guard let hexColor = args!["hexColor"] else {return}
                protectDataLeakageWithColor = hexColor
                enabledProtectDataLeakageWithColor = .on
            }
            break
        case "preventScreenshotOn":
            enabledPreventScreenshot = .on
            screenProtectorKit?.enabledPreventScreenshot()
            result(true)
            break
        case "preventScreenshotOff":
            enabledPreventScreenshot = .off
            screenProtectorKit?.disablePreventScreenshot()
            result(true)
            break
        case "addListener":
            screenProtectorKit?.removeScreenshotObserver()
            screenProtectorKit?.screenshotObserver {
                SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenshot", arguments: nil)
            }
            
            if #available(iOS 11.0, *) {
                screenProtectorKit?.removeScreenRecordObserver()
                screenProtectorKit?.screenRecordObserver { isCaptured in
                    SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenRecord", arguments: isCaptured)
                }
            }
            
            result("listened")
            break
        case "removeListener":
            screenProtectorKit?.removeAllObserver()
            
            result("removed")
            break
        case "isRecording":
            result(screenProtectorKit?.screenIsRecording() ?? false)
            return
        default:
            result(false)
            break
        }
    }
    
    deinit {
        screenProtectorKit?.removeAllObserver()
    }
}
