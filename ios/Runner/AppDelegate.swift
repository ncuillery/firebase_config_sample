import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()

    Analytics.setUserProperty("japan", forName: "app_country")
    Analytics.logEvent("app_created", parameters: nil)

    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings

    remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { (status, error) -> Void in
      if status == .success {
        print("Config fetched!")
        remoteConfig.activate() { (error) in
          print("Config activated!")
          print(remoteConfig.configValue(forKey: "country").stringValue!)
        }
      } else {
        print("Config not fetched")
        print("Error: \(error?.localizedDescription ?? "No error available.")")
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
