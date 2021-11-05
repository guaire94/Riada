//
//  MProfileSection.swift
//  Riada
//
//  Created by Guaire94 on 05/11/2021.
//

import UIKit

enum MProfileSection: Int {
    case organizer
    case participations
    case informations

    var cellIdentifier: String {
        switch self {
        case .organizer:
            return AnonymouslyCell.Constants.identifier
        case .participations:
            return SignInCell.Constants.identifier
        case .informations:
            return SignInCell.Constants.identifier
        }
    }

    var cellNib: UINib? {
        switch self {
        case .organizer:
            return AnonymouslyCell.Constants.nib
        case .participations:
            return SignInCell.Constants.nib
        case .informations:
            return SignInCell.Constants.nib
        }
    }
        
    var cellHeight: CGFloat {
        switch self {
        case .organizer:
            return AnonymouslyCell.Constants.height
        case .participations:
            return SignInCell.Constants.height
        case .informations:
            return SignInCell.Constants.height
        }
    }
    
    var title: String {
        switch self {
        case .organizer:
            return "Organizer"
        case .participations:
            return "Participations"
        case .informations:
            return "Informations"
        }
    }

    static func toDisplay() -> [MProfileSection] {
        [organizer, participations, informations]
    }
}
