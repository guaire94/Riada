//
//  Config.swift
//  Riada
//
//  Created by Quentin Gallois on 21/10/2020.
//

import UIKit

enum Config {
    static var AppStoreId = "1105748988" // TODO: replace appstore id
    static var AppStoreLink = "itms-apps://itunes.apple.com/app/id\(Config.AppStoreId)"
    static var googleAPIKey = "AIzaSyDTIlQBgK72dpao2XPISx1U60psDeshcGc"
    static let jpegCompressionQuality: CGFloat = 0.7
    static let defaultAvatar = UIImage(named: "avatar")

    #if DEBUG
        static var WormholyIsEnabled = true
        static var UpdateAppLangua = true
    #else
        static var WormholyIsEnabled = false
        static var UpdateAppLangua = false
    #endif
}
