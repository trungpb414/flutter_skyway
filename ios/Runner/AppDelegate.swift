import UIKit
import Flutter
import SkyWay

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let skyway = FlutterSkyway()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Create the Flutter platform client
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: Constants.METHOD_CHANNEL_NAME,
                                                 binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self?.skyway.handleMethod(methodCall: call, result: result)
        })
        GeneratedPluginRegistrant.register(with: self)
        
        // Register the platform view
        weak var registrar = self.registrar(forPlugin: Constants.SKYWAY_PLUGIN)
        let factory = NativeStreamViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: Constants.SKYWAY_PLATFORM_VIEW)!.register(
            factory,
            withId: Constants.SKYWAY_PLATFORM_VIEW_ID)
        skyway.setRegistrar(registrar)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
