//
//  UIViewController+M.swift
//  Riada
//
//  Created by Quentin Gallois on 20/10/2020.
//

import UIKit
import FirebaseAnalytics

// MARK: - Show alert
extension UIViewController {
    
    func showError(title: String, message: String) {
        let feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator.notificationOccurred(.error)
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10N.global.action.ok, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    static func display(sb: MStoryboard) {
        guard let vc = sb.storyboard.instantiateInitialViewController() else {
            fatalError("Load initial view controller from '\(sb.rawValue)' Storyboard have failed")
        }
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
