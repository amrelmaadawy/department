import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var privacyView: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    setupScreenshotPrevention()

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "com.codra.shatabha/security",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "enableSecure", "disableSecure":
          result(true)
        case "isJailbroken":
          result(self.checkJailbreak())
        case "isDeveloperMode":
          result(false)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupScreenshotPrevention() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(addPrivacyView),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(removePrivacyView),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
  }

  @objc private func addPrivacyView() {
    guard let window = window else { return }
    let view = UIView(frame: window.bounds)
    view.backgroundColor = UIColor.systemBackground
    window.addSubview(view)
    privacyView = view
  }

  @objc private func removePrivacyView() {
    privacyView?.removeFromSuperview()
    privacyView = nil
  }

  private func checkJailbreak() -> Bool {
    let paths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt"
    ]
    for path in paths {
      if FileManager.default.fileExists(atPath: path) {
        return true
      }
    }
    return false
  }
}
