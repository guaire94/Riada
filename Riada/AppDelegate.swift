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
import GoogleSignIn

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
    
    // MARK: - DeepLink
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:] ) -> Bool {
            return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        HelperTracking.track(item: .openDeeplinkTest(url: url.absoluteString))
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url),
           let deeplink = dynamicLink.url {
            HelperTracking.track(item: .openDeeplinkSuccess(url: deeplink.absoluteString))
            ManagerDeepLink.shared.setDeeplinkFromDeepLink(url: deeplink)
            HelperRouting.shared.routeToHome()
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let webpageURL = userActivity.webpageURL else {
                  return false
              }
        
        let isDynamicLinkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL) { dynamicLink, error in
            guard error == nil, let dynamicLink = dynamicLink, let url = dynamicLink.url else { return }
            
            ManagerDeepLink.shared.setDeeplinkFromDeepLink(url: url)
            HelperRouting.shared.routeToHome()
        }
        return isDynamicLinkHandled
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
    
    func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
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
            HelperRouting.shared.routeToHome()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard notification.request.content.userInfo is [String: Any] else {
            completionHandler([.alert, .sound])
            return
        }
//        NotificationHelper.shared.updateDisplay()
        completionHandler([.alert, .sound])
    }
}

