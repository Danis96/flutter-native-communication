import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let METHOD_CHANNEL_NAME = "com.abc.flutter/method"
    let PRESSURE_CHANNEL_NAME = "com.abc.flutter/pressure"
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    
    let pressureStreamHandler = PressureStreamHandler()
    
    let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
    
    methodChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        switch (call.method) {
        case "isPressureSensorAvailable":
            result(CMAltimeter.isRelativeAltitudeAvailable())
        case "getSystemInfo":
            result(getSystemAndVersion())
        case "getCalculation":
            result(tenPlusFive())
        default:
            result(FlutterMethodNotImplemented)
        }
    })
    
    let pressureChannel = FlutterEventChannel(name: PRESSURE_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
    pressureChannel.setStreamHandler(pressureStreamHandler)
    
    func getSystemAndVersion() -> String {
        let version = UIDevice.current.systemVersion
        return "IOS - \(version)"
    }
    
    func tenPlusFive() -> String {
        let number = 10 + 5;
        return String(number)
    }
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
