//
//  Config.swift
//  Riada
//
//  Created by Quentin Gallois on 21/10/2020.
//


enum Config {
    static var AppStoreLink = "itms-apps://itunes.apple.com/app/id1105748988" // TODO: replace appstore id
    
    #if DEBUG
        static var WormholyIsEnabled = true
        static var UpdateAppLangua = true
    #else
        static var WormholyIsEnabled = false
        static var UpdateAppLangua = false
    #endif
}
