import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "com.example.verygoodcore.tflusecases/native", binaryMessenger: controller.binaryMessenger)

    batteryChannel.setMethodCallHandler {(
      call: FlutterMethodCall, result: @escaping FlutterResult
    ) in 
    if call.method == "getBatteryLevel" {
      self.getBatteryLevel(result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }}
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getBatteryLevel(result: @escaping FlutterResult) {
    UIDevice.current.isBatteryMonitoringEnabled = true

    let batteryLevel = UIDevice.current.batteryLevel

    if batteryLevel >= 0.0 {
      result("\(Int(batteryLevel * 100))%")
    } else {
      result(
        FlutterError(code: "UNAVAILABLE", message: "Battery level not available", details: nil))
    }
  }
}
