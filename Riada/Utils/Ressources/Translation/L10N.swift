//
//  L10N.swift
//  Riada
//
//  Created by Quentin Gallois on 20/10/2020.
//

import Foundation

struct L10N {
    
    struct global {
        struct action {
            static let ok: String = NSLocalizedString("GLOBAL_ACTION_OK", comment: "")
            static let cancel: String = NSLocalizedString("GLOBAL_ACTION_CANCEL", comment: "")
            static let confirm: String = NSLocalizedString("GLOBAL_ACTION_CONFIRM", comment: "")
        }
    }
    
    struct onBoarding {
        static let title: String = NSLocalizedString("ONBOARDING_TITLE", comment: "")
        static let appDescription: String = NSLocalizedString("ONBOARDING_APP_DESCRIPTION", comment: "")
        static let favoriteSportDescription: String = NSLocalizedString("ONBOARDING_FAVORITE_SPORT_DESCRIPTION", comment: "")
        static let letsPlay: String = NSLocalizedString("ONBOARDING_LETS_PLAY", comment: "")
    }
    
    struct version {
        static let new: String = NSLocalizedString("VERSION_NEW", comment: "")
        static let available: String = NSLocalizedString("VERSION_AVAILABLE", comment: "")
        static let redirectAppStore: String = NSLocalizedString("VERSION_REDIRECT_APPSTORE", comment: "")
        static let updateLater: String = NSLocalizedString("VERSION_UPDATE_LATER", comment: "")
    }
}
