//
//  MSectionAsParticipant.swift
//  Riada
//
//  Created by Guaire94 on 25/09/2021.
//

import UIKit

enum MEventSectionAsParticipant: Int {
    case organizer
    case informations
    case place
    case placeWithPictures
    case participants
    case guests

    var cellIdentifier: String {
        switch self {
        case .organizer:
            return EventOrganizerCell.Constants.identifier
        case .informations:
            return EventInformationsCell.Constants.identifier
        case .place:
            return EventPlaceCell.Constants.identifier
        case .placeWithPictures:
            return EventPlaceWithPicturesCell.Constants.identifier
        case .participants, .guests:
            return EventParticipantCell.Constants.identifier
        }
    }

    var cellNib: UINib? {
        switch self {
        case .organizer:
            return EventOrganizerCell.Constants.nib
        case .informations:
            return EventInformationsCell.Constants.nib
        case .place:
            return EventPlaceCell.Constants.nib
        case .placeWithPictures:
            return EventPlaceWithPicturesCell.Constants.nib
        case .participants, .guests:
            return EventParticipantCell.Constants.nib
        }
    }
        
    var estimatedCellHeight: CGFloat {
        switch self {
        case .organizer:
            return EventOrganizerCell.Constants.height
        case .informations:
            return EventInformationsCell.Constants.height
        case .place:
            return EventPlaceCell.Constants.height
        case .placeWithPictures:
            return EventPlaceWithPicturesCell.Constants.height
        case .participants, .guests:
            return EventParticipantCell.Constants.height
        }
    }
    
    var desc: String? {
        switch self {
        case .organizer:
            return L10N.event.details.organizer
        case .informations:
            return L10N.event.details.informations
        case .place, .placeWithPictures:
            return L10N.event.details.place
        case .participants:
            return L10N.event.details.participants
        case .guests:
            return nil
        }
    }
    
    static let all: [MEventSectionAsParticipant] = [.organizer, .informations, .place, .placeWithPictures, .guests]
}
