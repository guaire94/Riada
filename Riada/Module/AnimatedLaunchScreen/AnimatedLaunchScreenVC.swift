//
//  AnimatedLaunchScreen.swift
//  Riada
//
//  Created by Quentin Gallois on 22/10/2020.
//

import UIKit

class AnimateLaunchScreenVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var version: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayVersion()
        checkIfUserNeedToUpdateApplication()
    }
    
    // MARK: - Privates
    private func displayVersion() {
        guard let dictionary = Bundle.main.infoDictionary,
            let v = dictionary["CFBundleShortVersionString"] as? String,
            let build = dictionary["CFBundleVersion"] as? String else {
            return
        }
        version.text = v.uppercased() + "." + build
    }
    
    private func checkIfUserNeedToUpdateApplication() {
        ServiceVersion.check { [weak self] (version) in
            guard let self = self else { return }
            guard let version = version, !version.in_review else {
                self.upToDate()
                return
            }
                        
            guard let dictionary = Bundle.main.infoDictionary,
                let localeVersion = dictionary["CFBundleShortVersionString"] as? String,
                version.latest != "",
                localeVersion != version.latest else {
                    self.upToDate()
                    return
            }
            
            if version.force_maj {
                self.majorUpdate()
            } else {
                self.updateAvailable()
            }
        }
    }
    
    private func loadUserIfNeeded() {
        guard ManagerUser.shared.isConnected else {
            ManagerSport.shared.synchronise {
                HelperRouting.shared.routeToOnBoarding()
            }
            return
        }
        
        ManagerUser.shared.synchronise {
            ManagerSport.shared.synchronise {
                HelperRouting.shared.routeToHome()
            }
        }
    }
}

// MARK: - Version
extension AnimateLaunchScreenVC {
    
    func upToDate() {
        loadUserIfNeeded()
    }
    
    func updateAvailable() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: L10N.version.new, message:
                L10N.version.available, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: L10N.version.redirectAppStore, style: .default, handler: { (_) in
                if let url = URL(string: Config.AppStoreLink), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            alertController.addAction(UIAlertAction(title: L10N.version.updateLater, style: .cancel, handler: { (_) in
                self.loadUserIfNeeded()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func majorUpdate() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: L10N.version.new, message:
                L10N.version.available, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: L10N.version.redirectAppStore, style: .default, handler: { (_) in
                if let url = URL(string: Config.AppStoreLink), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
