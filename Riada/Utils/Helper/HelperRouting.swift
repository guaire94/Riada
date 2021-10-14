//
//  HelperRouting.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

class HelperRouting {
    
    static let shared = HelperRouting()
    
    // MARK: - Public
    func routeToHome() {
        guard let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
              let _ = navVC.viewControllers.first as? HomeVC else {
                  UIViewController.display(sb: .Home)
                  handleRedirect()
                  return
              }
        navVC.popToRootViewController(animated: false)
        handleRedirect()
    }
    
    func routeToOnBoarding() {
        UIViewController.display(sb: .OnBoarding)
    }
    
    // MARK: - Private
    private func handleRedirect() {
        guard let currentDeepLink = ManagerDeepLink.shared.currentDeepLink,
              let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }

        switch currentDeepLink {
        case let .eventDetails(eventId: eventId):
            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            
            let eventDetailsVC = UIViewController.eventDetailsVC
            
            ServiceEvent.getEventOrganizer(eventId: eventId) { organizer in
                //TODO: verify if owner
                ServiceEvent.getEventDetails(eventId: eventId) { event in
                    eventDetailsVC.event = event
                    eventDetailsVC.organizer = organizer
                    DispatchQueue.main.async {
                        let navigationController = UINavigationController(rootViewController: eventDetailsVC)
                        navigationController.navigationBar.isHidden = true
                        rootViewController.show(eventDetailsVC, sender: self)
                    }
                }
            }
        }
    }
}
