//
//  MSignUpSection.swift
//  Riada
//
//  Created by Guaire94 on 25/09/2021.
//

import UIKit

enum MSignUpSection: Int {
    case anonymously
    case signIn

    var cellIdentifier: String {
        switch self {
        case .anonymously:
            return AnonymouslyCell.Constants.identifier
        case .signIn:
            return SignInCell.Constants.identifier
        }
    }

    var cellNib: UINib? {
        switch self {
        case .anonymously:
            return AnonymouslyCell.Constants.nib
        case .signIn:
            return SignInCell.Constants.nib
        }
    }
        
    var cellHeight: CGFloat {
        switch self {
        case .anonymously:
            return AnonymouslyCell.Constants.height
        case .signIn:
            return SignInCell.Constants.height
        }
    }
    
    var desc: String {
        switch self {
        case .anonymously:
            return L10N.signUp.anonymously
        case .signIn:
            return L10N.signUp.signIn
        }
    }

    
    static func toDisplay() -> [MSignUpSection] {
        [anonymously, signIn]
    }
}
