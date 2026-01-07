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
    private var screenProtectorKit: ScreenProtectorKit?
    private weak var trackedWindow: UIWindow?
    private var sceneObservers: [NSObjectProtocol] = []
    private var preventScreenshotState: ProtectionState = .idle
    private var blurProtectionState: ProtectionState = .idle
    private var imageProtectionState: ProtectionState = .idle
    private var colorProtectionState: ProtectionState = .idle
    private var imageProtectionName: String = ""
    private var colorProtectionHex: String = ""
    private var needAddListener: Bool = false
    
    override public init() {
        super.init()
        observeSceneLifecycle()
    }
    
    private func initializeManagerIfNeeded(forceRecreate: Bool = false) {
        if Thread.isMainThread == false {
            DispatchQueue.main.async { [weak self] in
                self?.initializeManagerIfNeeded(forceRecreate: forceRecreate)
            }
            return
        }
        
        let currentWindow = Self.activeWindow()
        
        if forceRecreate || (trackedWindow != nil && currentWindow !== trackedWindow) {
            self.didBecomeActive(.dataLeakage)
            tearDownManager()
        }
        
        guard screenProtectorKit == nil else { return }
        guard let window = currentWindow else {
            self.log()
            // Disable data leakage protection when no active UIWindow is available
            self.didBecomeActive(.dataLeakage)
            print("[screen_protector] Active UIWindow is not available.")
            return
        }
        
        self.screenProtectorKit = ScreenProtectorKit(window: window)
        onMain { self.screenProtectorKit?.configurePreventionScreenshot() }
        onMain { self.addListenerIfNeeded() }
        
        self.trackedWindow = window
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftScreenProtectorPlugin.channel = FlutterMethodChannel(name: "screen_protector", binaryMessenger: registrar.messenger())
        let instance = SwiftScreenProtectorPlugin()
        registrar.addMethodCallDelegate(instance, channel: SwiftScreenProtectorPlugin.channel!)
        
        // Initialize manager safely on main thread and scene lifecycle
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(
                instance,
                selector: #selector(instance.onSceneDidBecomeActive),
                name: UIScene.didActivateNotification,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                instance,
                selector: #selector(instance.onSceneWillResignActive),
                name: UIScene.willDeactivateNotification,
                object: nil
            )
        }
    }
    
    public func willResignActive(_ type: ProtectionType) {
        if type == .dataLeakage {
            // Protect Data Leakage - ON
            if colorProtectionState == .on {
                onMain { self.screenProtectorKit?.enabledColorScreen(hexColor: self.colorProtectionHex) }
            } else if imageProtectionState == .on {
                onMain { self.screenProtectorKit?.enabledImageScreen(named: self.imageProtectionName) }
            } else if blurProtectionState == .on {
                onMain { self.screenProtectorKit?.enabledBlurScreen() }
            }
        }
        
        if type == .screenshot {
            // Prevent Screenshot - OFF
            if preventScreenshotState == .off {
                onMain { self.screenProtectorKit?.disablePreventScreenshot() }
            }
        }
    }
    
    public func didBecomeActive(_ type: ProtectionType) {
        if type == .dataLeakage {
            // Protect Data Leakage - OFF
            if colorProtectionState == .on {
                onMain { self.screenProtectorKit?.disableColorScreen() }
            } else if imageProtectionState == .on {
                onMain { self.screenProtectorKit?.disableImageScreen() }
            } else if blurProtectionState == .on {
                onMain { self.screenProtectorKit?.disableBlurScreen() }
            }
        }
        
        if type == .screenshot {
            // Prevent Screenshot - ON
            if preventScreenshotState == .on {
                onMain { self.screenProtectorKit?.enabledPreventScreenshot() }
            }
        }
    }
    
    @objc func onSceneDidBecomeActive(_ notification: Notification) {
        // Protect Data Leakage - OFF && Prevent Screenshot - ON
        DispatchQueue.main.async {
            self.initializeManagerIfNeeded(forceRecreate: true)
            self.didBecomeActive(.dataLeakage)
            self.didBecomeActive(.screenshot)
        }
    }
    
    @objc func onSceneWillResignActive(_ notification: Notification) {
        // Protect Data Leakage - ON && Prevent Screenshot - OFF
        DispatchQueue.main.async {
            self.initializeManagerIfNeeded()
            self.willResignActive(.dataLeakage)
            self.willResignActive(.screenshot)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>
        DispatchQueue.main.async {
            self.initializeManagerIfNeeded()
            switch call.method {
            case "protectDataLeakageWithBlur":
                self.blurProtectionState = .on
                result(true)
                break
            case "protectDataLeakageWithBlurOff":
                self.blurProtectionState = .off
                self.screenProtectorKit?.disableBlurScreen()
                result(true)
                break
            case "protectDataLeakageWithImage":
                if args != nil {
                    self.imageProtectionName = args!["name"] ?? "LaunchImage"
                }
                self.imageProtectionState = .on
                result(true)
                break
            case "protectDataLeakageWithImageOff":
                self.imageProtectionName = ""
                self.imageProtectionState = .off
                result(true)
                break
            case "protectDataLeakageWithColor":
                guard let args = args, let hexColor = args["hexColor"] else {
                    result(false)
                    return
                }
                self.colorProtectionHex = hexColor
                self.colorProtectionState = .on
                break
            case "protectDataLeakageWithColorOff":
                self.colorProtectionHex = ""
                self.colorProtectionState = .off
                self.screenProtectorKit?.disableColorScreen()
                result(true)
                break
            case "protectDataLeakageOff":
                self.colorProtectionState = .off
                self.imageProtectionState = .off
                self.blurProtectionState = .off
                self.screenProtectorKit?.disableColorScreen()
                self.screenProtectorKit?.disableImageScreen()
                self.screenProtectorKit?.disableBlurScreen()
                result(true)
                break
            case "preventScreenshotOn":
                self.preventScreenshotState = .on
                self.screenProtectorKit?.enabledPreventScreenshot()
                result(true)
                break
            case "preventScreenshotOff":
                self.preventScreenshotState = .off
                self.screenProtectorKit?.disablePreventScreenshot()
                result(true)
                break
            case "addListener":
                self.addListener()
                result("listened")
                break
            case "removeListener":
                self.needAddListener = false
                self.screenProtectorKit?.removeAllObserver()
                result("removed")
                break
            case "isRecording":
                result(self.screenProtectorKit?.screenIsRecording() ?? false)
                break
            default:
                result(false)
                break
            }
        }
    }
    
    private func addListener() {
        self.needAddListener = true
        self.screenProtectorKit?.removeScreenshotObserver()
        self.screenProtectorKit?.screenshotObserver {
            SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenshot", arguments: nil)
        }
        
        if #available(iOS 11.0, *) {
            self.screenProtectorKit?.removeScreenRecordObserver()
            self.screenProtectorKit?.screenRecordObserver { isRecording in
                SwiftScreenProtectorPlugin.channel?.invokeMethod("onScreenRecord", arguments: isRecording)
            }
        }
    }
    
    private func addListenerIfNeeded() {
        if self.needAddListener {
            self.addListener()
        }
    }
    
    private func observeSceneLifecycle() {
        guard #available(iOS 13.0, *) else { return }
        let center = NotificationCenter.default
        
        let disconnectObserver = center.addObserver(forName: UIScene.didDisconnectNotification, object: nil, queue: .main) { [weak self] notification in
            guard let scene = notification.object as? UIWindowScene,
                  let trackedScene = self?.trackedWindow?.windowScene,
                  trackedScene == scene else { return }
            self?.tearDownManager()
        }
        
        let foregroundObserver = center.addObserver(forName: UIScene.didActivateNotification, object: nil, queue: .main) { [weak self] _ in
            self?.initializeManagerIfNeeded(forceRecreate: true)
        }
        
        sceneObservers.append(contentsOf: [disconnectObserver, foregroundObserver])
    }
    
    private func tearDownManager() {
        onMain { self.screenProtectorKit?.removeAllObserver() }
        screenProtectorKit = nil
        trackedWindow = nil
    }
    
    private static func activeWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
    
    private func log() {
        #if DEBUG
        print("[screen_protector] screenProtectorKit: \(String(describing: screenProtectorKit))")
        print("[screen_protector] trackedWindow: \(String(describing: trackedWindow))")
        print("[screen_protector] sceneObservers: \(sceneObservers)")
        print("[screen_protector] preventScreenshotState: \(preventScreenshotState)")
        print("[screen_protector] blurProtectionState: \(blurProtectionState)")
        print("[screen_protector] imageProtectionState: \(imageProtectionState)")
        print("[screen_protector] colorProtectionState: \(colorProtectionState)")
        print("[screen_protector] imageProtectionName: \(imageProtectionName)")
        print("[screen_protector] colorProtectionHex: \(colorProtectionHex)")
        print("[screen_protector] needAddListener: \(needAddListener)")
        #endif
    }
    
    deinit {
        sceneObservers.forEach { NotificationCenter.default.removeObserver($0) }
        tearDownManager()
    }
}

