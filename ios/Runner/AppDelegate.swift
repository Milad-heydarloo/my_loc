import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let locationService = LocationService.shared

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // شروع به‌روزرسانی مکان
    locationService.startUpdatingLocation()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
