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
                  ManagerSport.shared.synchronise {
                      UIViewController.display(sb: .Home)
                      self.handleRedirect()
                  }
                  return
              }
        navVC.popToRootViewController(animated: false)
        handleRedirect()
    }
    
    func routeToOnBoarding() {
        UIViewController.display(sb: .OnBoarding)
    }
    
    func handleRedirect() {
        guard let currentDeepLink = ManagerDeepLink.shared.currentDeepLink else { return }
        ManagerDeepLink.shared.clear()
        
        switch currentDeepLink {
        case let .eventDetails(eventId: eventId):
            ServiceEvent.getEventOrganizer(eventId: eventId) { organizer in
                guard let organizer = organizer else { return }
                ServiceEvent.getEventDetails(eventId: eventId) { event in
                    guard let event = event else { return }
                    if organizer.userId == ManagerUser.shared.user?.id {
                        let eventDetailsVC = UIViewController.eventDetailsAsOrganizerVC
                        eventDetailsVC.event = event
                        self.routeToVC(vc: eventDetailsVC)
                    } else {
                        let eventDetailsVC = UIViewController.eventDetailsAsParticipantVC
                        eventDetailsVC.event = event
                        eventDetailsVC.organizer = organizer
                        self.routeToVC(vc: eventDetailsVC)
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    private func routeToVC(vc: UIViewController) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)

        DispatchQueue.main.async {
            rootViewController.show(vc, sender: self)
        }
    }

}
