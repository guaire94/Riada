//
//  HelperRouting.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

class HelperRouting {
    
    static let shared = HelperRouting()
    
    // MARK: - Properties
    private var isReadyToRedirect: Bool = false

    // MARK: - Public
    func routeToHome() {
        isReadyToRedirect = true
        UIViewController.display(sb: .Home)
        handleRedirect()
    }
    
    func routeToOnBoarding() {
        UIViewController.display(sb: .OnBoarding)
    }
    
    func redirect() {
        guard isReadyToRedirect else { return }
        handleRedirect()
    }
    
    // MARK: - Private
    private func handleRedirect() {
//        guard let currentDeepLink = ManagerDeepLink.shared.currentDeepLink,
//              let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
//
//        switch currentDeepLink {
//        case let .eventDetails(eventId: eventId):
//            UIViewController.display(sb: .OnBoarding)
//
//            guard let eventDetailsVC = UIViewController.eventDetailsVC else { return }
//
//            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
//
//            eventDetailsVC.eventId = eventId
//            let navigationController = UINavigationController(rootViewController: eventDetailsVC)
//            navigationController.navigationBar.isHidden = true
//
//            rootViewController.present(navigationController, animated: true, completion: nil)
//            break
//        }
    }
}
