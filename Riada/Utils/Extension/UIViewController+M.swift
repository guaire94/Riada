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
        HelperTracking.track(item: .alertError(title: title, message: message))
        
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
    
    static var eventDetailsAsParticipantVC: EventDetailsAsParticipantVC {
        guard let eventDetailsAsParticipant = MStoryboard.Event.storyboard.instantiateViewController(withIdentifier: EventDetailsAsParticipantVC.Constants.identifier) as? EventDetailsAsParticipantVC else {
            fatalError("Load initial view controller from '\(MStoryboard.Event.rawValue)' Storyboard have failed")
        }
        
        return eventDetailsAsParticipant
    }
    
    static var eventDetailsAsOrganizerVC: EventDetailsAsOrganizerVC {
        guard let eventDetailsAsOrganizer = MStoryboard.Event.storyboard.instantiateViewController(withIdentifier: EventDetailsAsOrganizerVC.Constants.identifier) as? EventDetailsAsOrganizerVC else {
            fatalError("Load initial view controller from '\(MStoryboard.Event.rawValue)' Storyboard have failed")
        }
        
        return eventDetailsAsOrganizer
    }
}
