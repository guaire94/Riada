//
//  Config.swift
//  Riada
//
//  Created by Quentin Gallois on 21/10/2020.
//

import UIKit

enum Config {
    static let AppStoreId = "1596416057"
    static let AppStoreLink = "itms-apps://itunes.apple.com/app/id\(Config.AppStoreId)"
    static let googleAPIKey = "AIzaSyDTIlQBgK72dpao2XPISx1U60psDeshcGc"
    static let jpegCompressionQuality: CGFloat = 0.7
    static let defaultAvatar = UIImage(named: "avatar")
    static let androidPackageName = "com.riada.app"
    
    #if DEBUG
        static let WormholyIsEnabled = true
        static let UpdateAppLangua = false
        static let firebaseEnv = "Staging"
    #else
        static var WormholyIsEnabled = false
        static var UpdateAppLangua = false
        static let firebaseEnv = "Release"
    #endif
}
