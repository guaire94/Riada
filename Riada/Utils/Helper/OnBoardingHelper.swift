//
//  OnBoardingHelper.swift
//  Riada
//
//  Created by P995987 on 24/12/2020.
//

import Foundation

class OnBoardingHelper: NSObject {
    
    static let shared = OnBoardingHelper()
    
    var haveSeenWelcomeMessage: Bool {
        get {
            guard ManagerAuth.shared.isConnected == false else {
                UserDefaults.standard.set(true, forKey: "haveSeenWelcomeMessage")
                return true
            }
            
            let authorize = UserDefaults.standard.bool(forKey: "haveSeenWelcomeMessage")
            return authorize
        }
        set {
           UserDefaults.standard.set(newValue, forKey: "haveSeenWelcomeMessage")
        }
    }
    
    var haveSeenOnboardingMap: Bool {
        get {
            let authorize = UserDefaults.standard.bool(forKey: "haveSeenOnboardingMap")
            return authorize
        }
        set {
           UserDefaults.standard.set(newValue, forKey: "haveSeenOnboardingMap")
        }
    }
    
    var haveSeenOnboardingAgenda: Bool {
        get {
            let authorize = UserDefaults.standard.bool(forKey: "haveSeenOnboardingAgenda")
            return authorize
        }
        set {
           UserDefaults.standard.set(newValue, forKey: "haveSeenOnboardingAgenda")
        }
    }
    
    var haveSeenOnboardingChat: Bool {
        get {
            let authorize = UserDefaults.standard.bool(forKey: "haveSeenOnboardingChat")
            return authorize
        }
        set {
           UserDefaults.standard.set(newValue, forKey: "haveSeenOnboardingChat")
        }
    }
}
