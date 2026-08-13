import Flutter
import UIKit
import ScreenProtectorKit

enum ScrennProtectorMethod: String {
    case protectDataLeakageWithBlur
    case protectDataLeakageWithBlurOff
    case protectDataLeakageWithImage
    case protectDataLeakageWithImageOff
    case protectDataLeakageWithColor
    case protectDataLeakageWithColorOff
    case protectDataLeakageOff
    case preventScreenshotOn
    case preventScreenshotOff
    case preventScreenRecordOn
    case preventScreenRecordOff
    case addListener
    case removeListener
    case isRecording
}

public class SwiftScreenProtectorPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel? = nil
    private let protectKit: ScreenProtectorKit
    private var protectMode: ScreenProtectorMode = .none
    private var isPreventScreenshotEnabled = false

    init(_ screenProtector: ScreenProtectorKit) {
        self.protectKit = screenProtector
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftScreenProtectorPlugin.channel = FlutterMethodChannel(name: "screen_protector", binaryMessenger: registrar.messenger())

        let kit = ScreenProtectorKit(window: SwiftScreenProtectorPlugin.keyWindow())
        kit.setRootViewResolver(FlutterRootViewResolver())
        ScreenProtectorKit.initial(with: kit.window?.rootViewController?.view)
        let instance = SwiftScreenProtectorPlugin(kit)
        
        registrar.addMethodCallDelegate(instance, channel: SwiftScreenProtectorPlugin.channel!)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if Thread.isMainThread {
            handleFunc(call, result: result)
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.handleFunc(call, result: result)
        }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        updateWindowIfNeeded()
        applyDataLeakageProtection()
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        updateWindowIfNeeded()
        clearDataLeakageProtection()
    }

    deinit {
        updateWindowIfNeeded()
        protectKit.removeAllObserver()
        protectKit.disablePreventScreenshot()
        protectKit.disablePreventScreenRecording()
        clearDataLeakageProtection()
    }
}

private extension SwiftScreenProtectorPlugin {
    func handleFunc(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>

        switch ScrennProtectorMethod(rawValue: call.method) {
        case .protectDataLeakageWithBlur:
            setDataLeakageProtectMode(.blur)
            result(true)
            break
        case .protectDataLeakageWithBlurOff:
            if case .blur = protectMode {
                protectMode = .none
            }
            protectKit.disableBlurScreen()
            result(true)
            break
        case .protectDataLeakageWithImage:
            setDataLeakageProtectMode(.image(name: args?["name"] ?? "LaunchImage"))
            result(true)
            break
        case .protectDataLeakageWithImageOff:
            if case .image = protectMode {
                protectMode = .none
            }
            protectKit.disableImageScreen()
            result(true)
            break
        case .protectDataLeakageWithColor:
            guard let hexColor = args?["hexColor"] else {
                result(false)
                return
            }
            setDataLeakageProtectMode(.color(hex: hexColor))
            result(true)
            break
        case .protectDataLeakageWithColorOff:
            if case .color = protectMode {
                protectMode = .none
            }
            protectKit.disableColorScreen()
            result(true)
            break
        case .protectDataLeakageOff:
            protectMode = .none
            clearDataLeakageProtection()
            result(true)
            break
        case .preventScreenshotOn:
            isPreventScreenshotEnabled = true
            updateWindowIfNeeded()
            protectKit.enabledPreventScreenshot()
            configureScreenshotProtectorAccessibility()
            result(true)
            break
        case .preventScreenshotOff:
            isPreventScreenshotEnabled = false
            updateWindowIfNeeded()
            protectKit.disablePreventScreenshot()
            result(true)
            break
        case .preventScreenRecordOn:
            updateWindowIfNeeded()
            protectKit.enabledPreventScreenRecording()
            configureScreenshotProtectorAccessibility()
            result(true)
            break
        case .preventScreenRecordOff:
            updateWindowIfNeeded()
            protectKit.disablePreventScreenRecording()
            result(true)
            break
        case .addListener:
            protectKit.screenshotObserver { [weak channel = SwiftScreenProtectorPlugin.channel] in
                channel?.invokeMethod("onScreenshot", arguments: nil)
            }
            if #available(iOS 11.0, *) {
                protectKit.screenRecordObserver { [weak channel = SwiftScreenProtectorPlugin.channel] isCaptured in
                    channel?.invokeMethod("onScreenRecord", arguments: isCaptured)
                }
            }
            result("listened")
            break
        case .removeListener:
            protectKit.removeAllObserver()
            result("removed")
            break
        case .isRecording:
            if #available(iOS 11.0, *) {
                result(protectKit.screenIsRecording())
            } else {
                result(false)
            }
            break
        default:
            result(false)
            break
        }
    }
    
    func updateWindowIfNeeded() {
        if let window = Self.keyWindow() {
            protectKit.window = window
        }
    }

    func configureScreenshotProtectorAccessibility() {
        let configure = { [weak self] in
            guard let self = self else { return }
            for window in Self.accessibilityWindows() {
                self.configureScreenshotProtectorAccessibility(in: window)
            }

            if UIAccessibility.isVoiceOverRunning {
                UIAccessibility.post(notification: .layoutChanged, argument: nil)
            }
        }

        configure()
        DispatchQueue.main.async(execute: configure)
    }

    func configureScreenshotProtectorAccessibility(in view: UIView) {
        if isScreenshotProtectorView(view) {
            view.isAccessibilityElement = false
            view.accessibilityElementsHidden = false
            view.shouldGroupAccessibilityChildren = false
            view.accessibilityViewIsModal = false
        }

        for child in view.subviews {
            configureScreenshotProtectorAccessibility(in: child)
        }
    }

    func isScreenshotProtectorView(_ view: UIView) -> Bool {
        let className = String(reflecting: type(of: view))
        if className.contains("ScreenPreventerKit") ||
            className.contains("ScreenProtectorKit") ||
            className.contains("ScreenshotProtection") {
            return true
        }

        guard let textField = view as? UITextField,
              textField.isSecureTextEntry,
              textField.text?.isEmpty ?? true,
              textField.placeholder == nil else {
            return false
        }

        return textField.superview is UIWindow ||
            (!textField.isUserInteractionEnabled &&
                hasScreenshotProtectorAncestor(textField))
    }

    func hasScreenshotProtectorAncestor(_ view: UIView) -> Bool {
        var ancestor = view.superview
        while let current = ancestor {
            let className = String(reflecting: type(of: current))
            if className.contains("ScreenPreventerKit") ||
                className.contains("ScreenProtectorKit") ||
                className.contains("ScreenshotProtection") {
                return true
            }
            ancestor = current.superview
        }
        return false
    }

    func applyDataLeakageProtection() {
        updateWindowIfNeeded()
        clearDataLeakageProtection()
        switch protectMode {
        case .blur:
            protectKit.enabledBlurScreen()
        case let .image(name):
            protectKit.enabledImageScreen(named: name)
        case let .color(hex):
            protectKit.enabledColorScreen(hexColor: hex)
        case .none:
            break
        }
    }

    func clearDataLeakageProtection() {
        protectKit.disableBlurScreen()
        protectKit.disableImageScreen()
        protectKit.disableColorScreen()
    }

    func setDataLeakageProtectMode(_ mode: ScreenProtectorMode) {
        protectMode = mode
        if UIApplication.shared.applicationState != .active {
            applyDataLeakageProtection()
        } else {
            clearDataLeakageProtection()
        }
    }

    static func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
        return UIApplication.shared.keyWindow
    }

    static func accessibilityWindows() -> [UIWindow] {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        }
        return UIApplication.shared.windows
    }
}
