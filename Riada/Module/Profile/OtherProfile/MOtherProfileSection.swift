//
//  MProfileSection.swift
//  Riada
//
//  Created by Guaire94 on 05/11/2021.
//

import UIKit

enum MOtherProfileSection: Int {
    case organizer
    case participate

    var cellIdentifier: String {
        switch self {
        case .organizer:
            return RelatedEventCell.Constants.identifier
        case .participate:
            return RelatedEventCell.Constants.identifier
        }
    }

    var cellNib: UINib? {
        switch self {
        case .organizer:
            return RelatedEventCell.Constants.nib
        case .participate:
            return RelatedEventCell.Constants.nib
        }
    }
        
    var cellHeight: CGFloat {
        switch self {
        case .organizer:
            return RelatedEventCell.Constants.height
        case .participate:
            return RelatedEventCell.Constants.height
        }
    }
    
    var sectionHeight: CGFloat {
        SectionCell.Constants.height
    }
    
    var title: String {
        switch self {
        case .organizer:
            return L10N.otherProfile.organizer
        case .participate:
            return L10N.otherProfile.participate
        }
    }

    static func toDisplay() -> [MOtherProfileSection] {
        [organizer, participate]
    }
}
