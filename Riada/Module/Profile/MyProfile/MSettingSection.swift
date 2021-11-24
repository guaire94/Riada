//
//  MSetting.swift
//  Riada
//
//  Created by P995987 on 09/12/2020.
//

import UIKit

enum MSettingSection: Int {
    case notifications
    case rateApp
    case contactUs
    case privacyPolicy
    case termsAndConditions
    case logout


    var cellIdentifier: String {
        SettingCell.Constants.identifier
    }

    var cellNib: UINib? {
        SettingCell.Constants.nib
    }
        
    var cellHeight: CGFloat {
        SettingCell.Constants.height
    }
    
    var title: String {
        switch self {
        case .notifications:
            return L10N.setting.list.notifications
        case .rateApp:
            return L10N.setting.list.rateApp
        case .contactUs:
            return L10N.setting.list.contactUs
        case .privacyPolicy:
            return L10N.setting.list.privacyPolicy
        case .termsAndConditions:
            return L10N.setting.list.termsAndConditions
        case .logout:
            return L10N.setting.list.logout
        }
    }
    
    var url: String? {
        switch self {
        case .privacyPolicy:
            return "https://social-sport-c41f3.web.app/privacy-policy.html"
        case .termsAndConditions:
            return "https://social-sport-c41f3.web.app/terms-and-conditions.html"
        default:
            return nil
        }
    }

    static func toDisplay() -> [MSettingSection] {
        [.notifications, .contactUs, .rateApp, .privacyPolicy, .termsAndConditions, .logout]
    }
}

