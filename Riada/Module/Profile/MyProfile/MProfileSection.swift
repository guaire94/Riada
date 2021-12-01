//
//  MProfileSection.swift
//  Riada
//
//  Created by Guaire94 on 05/11/2021.
//

import UIKit

enum MProfileSection: Int {
    case organizer
    case participate
    case informations

    var cellIdentifier: String {
        switch self {
        case .organizer, .participate:
            return RelatedEventCell.Constants.identifier
        case .informations:
            return InformationsCell.Constants.identifier
        }
    }

    var cellNib: UINib? {
        switch self {
        case .organizer, .participate:
            return RelatedEventCell.Constants.nib
        case .informations:
            return InformationsCell.Constants.nib
        }
    }
        
    var estimatedCellHeight: CGFloat {
        switch self {
        case .organizer, .participate:
            return RelatedEventCell.Constants.height
        case .informations:
            return InformationsCell.Constants.height
        }
    }
    
    var sectionHeight: CGFloat {
        switch self {
        case .organizer, .participate:
            return SectionCell.Constants.height
        case .informations:
            return .zero
        }
    }
    
    var title: String {
        switch self {
        case .organizer:
            return L10N.profile.organizer
        case .participate:
            return L10N.profile.participate
        case .informations:
            return L10N.profile.informations
        }
    }

    static func toDisplay() -> [MProfileSection] {
        [organizer, participate, informations]
    }
}
