//
//  AppDelegate.swift
//  Riada
//
//  Created by Quentin Gallois on 19/10/2020.
//

import UIKit
import Firebase
import Wormholy
import Applanga

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setUpWormholy()
        setUpAppLangua()
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    private func setUpWormholy() {
        Wormholy.shakeEnabled = Config.WormholyIsEnabled
    }
    
    private func setUpAppLangua() {
        if Config.UpdateAppLangua {
            Applanga.update { (success: Bool) in }
        }
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - DeepLink
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:] ) -> Bool {
        if let scheme = url.scheme, scheme.localizedCaseInsensitiveCompare("riada") == .orderedSame {
            ManagerDeepLink.shared.setDeeplinkFromDeepLink(url: url)
            HelperRouting.shared.redirect()
        }
        return false
    }
}

// MARK: Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        ServiceDeviceToken.shared.register()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let info = userInfo as? [String: Any] else { return }
        
        ManagerDeepLink.shared.setDeeplinkFromNotification(info: info)
        if application.applicationState != .inactive {
            HelperRouting.shared.redirect()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard notification.request.content.userInfo is [String: Any] else {
            completionHandler([.alert, .sound])
            return
        }
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let info = response.notification.request.content.userInfo as? [String: Any] else {
            completionHandler()
            return
        }
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            HelperNotification.shared.setCurrentNotification(info: info)
//            NotificationCenter.default.post(name: .OpenRemoteNotification, object: nil)
            print("Open Action")
        default:
            print("default")
        }
        completionHandler()
    }
}

