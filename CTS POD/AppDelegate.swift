
import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (flag, error) in
        }
        Messaging.messaging().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        IQKeyboardManager.shared.enable = true
        CLLocationManager().requestAlwaysAuthorization()        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            
            if navigationController.visibleViewController is SignViewController {
                return UIInterfaceOrientationMask.landscapeLeft
            } else {
                return UIInterfaceOrientationMask.portrait
            }
        }
        return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKeys.fcmToke)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let controller = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
            let dashboard = controller.findViewController(type: DashboardViewController.self)
            dashboard?.fetchJobList()
        }
    }
}
