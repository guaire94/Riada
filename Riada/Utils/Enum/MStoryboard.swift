//
//  MStoryboard.swift
//  Riada
//
//  Created by Quentin Gallois on 22/10/2020.
//

import UIKit

enum MStoryboard: String {
    case AnimateLaunchScreen = "AnimateLaunchScreen"
    case OnBoarding = "OnBoarding"
    case Home = "Home"
    case Event = "Event"

    var storyboard: UIStoryboard {
        UIStoryboard(name: rawValue, bundle: nil)
    }
}
