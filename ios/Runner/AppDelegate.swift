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
}
