import Flutter
import UIKit
import ScreenProtectorKit

public class SwiftScreenProtectorPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel? = nil
    private var screenProtectorKitManager: ScreenProtectorKitManager?
    private weak var trackedWindow: UIWindow?
    private var trackedStateSnapshot: StateSnapshot?
    private var sceneObservers: [NSObjectProtocol] = []
    
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
            tearDownManager()
        }
        
        guard screenProtectorKitManager == nil else { return }
        guard let window = currentWindow else {
            // Disable data leakage protection when no active UIWindow is available
            self.screenProtectorKitManager?.applicationWillResignActive(.dataLeakage)
            print("[screen_protector] Active UIWindow is not available.")
            return
        }
        
        let kit = ScreenProtectorKit(window: window)
        self.screenProtectorKitManager = ScreenProtectorKitManager(screenProtectorKit: kit)
        
        // Restore previously tracked protection state (if any) when recreating the manager
        if let stateSnapshot = self.trackedStateSnapshot {
            self.screenProtectorKitManager?.setStateSnapshot(stateSnapshot)
        }
        self.trackedWindow = window
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
            self.screenProtectorKitManager?.applicationWillResignActive(.dataLeakage)
            self.screenProtectorKitManager?.applicationWillResignActive(.screenshot)
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Protect Data Leakage - OFF && Prevent Screenshot - ON
        DispatchQueue.main.async {
            self.screenProtectorKitManager?.applicationDidBecomeActive(.dataLeakage)
            self.initializeManagerIfNeeded(forceRecreate: true)
            self.screenProtectorKitManager?.applicationDidBecomeActive(.screenshot)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>
        DispatchQueue.main.async {
            self.initializeManagerIfNeeded()
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
    
    private func observeSceneLifecycle() {
        guard #available(iOS 13.0, *) else { return }
        let center = NotificationCenter.default
        
        let disconnectObserver = center.addObserver(forName: UIScene.didDisconnectNotification, object: nil, queue: .main) { [weak self] notification in
            guard let scene = notification.object as? UIWindowScene,
                  let trackedScene = self?.trackedWindow?.windowScene,
                  trackedScene == scene else { return }
            self?.tearDownManager()
        }
        
        let foregroundObserver = center.addObserver(forName: UIScene.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.initializeManagerIfNeeded(forceRecreate: true)
        }
        
        sceneObservers.append(contentsOf: [disconnectObserver, foregroundObserver])
    }
    
    private func tearDownManager() {
        // Preserve current protection state, remove listeners, and release manager/window references
        trackedStateSnapshot = screenProtectorKitManager?.getStateSnapshot()
        screenProtectorKitManager?.removeListeners()
        screenProtectorKitManager = nil
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
    
    deinit {
        sceneObservers.forEach { NotificationCenter.default.removeObserver($0) }
        tearDownManager()
    }
}

