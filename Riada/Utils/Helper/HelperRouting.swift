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
        UIViewController.display(sb: .Home)
    }
    
    func routeToOnBoarding() {
        UIViewController.display(sb: .OnBoarding)
    }
}
