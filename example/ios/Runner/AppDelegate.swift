import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterEngine: FlutterEngine?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.flutterEngine = FlutterEngine(name: "my_engine")
        self.flutterEngine?.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine!)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        bgTask = application.beginBackgroundTask {
            application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        }
    }
}
