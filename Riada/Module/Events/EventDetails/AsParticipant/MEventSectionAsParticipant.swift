//
//  MSectionAsParticipant.swift
//  Riada
//
//  Created by Guaire94 on 25/09/2021.
//

import UIKit

enum MEventSectionAsParticipant: Int {
    case title
    case desc
    case dateAndHour
    case place
    case placeWithPictures
    case organizer
    case team
    case myGuests

    var cellIdentifier: String {
        switch self {
        case .title:
            return EventTitleCell.Constants.identifier
        case .desc:
            return EventDescriptionCell.Constants.identifier
        case .dateAndHour:
            return EventDateAndHourCell.Constants.identifier
        case .place:
            return EventPlaceCell.Constants.identifier
        case .placeWithPictures:
            return EventPlaceWithPicturesCell.Constants.identifier
        case .organizer:
            return EventOrganizerCell.Constants.identifier
        case .team:
            return EventTeamsCell.Constants.identifier
        case .myGuests:
            return EventMyGuestsCell.Constants.identifier
        }
    }

    var cellNib: UINib? {
        switch self {
        case .title:
            return EventTitleCell.Constants.nib
        case .desc:
            return EventDescriptionCell.Constants.nib
        case .dateAndHour:
            return EventDateAndHourCell.Constants.nib
        case .place:
            return EventPlaceCell.Constants.nib
        case .placeWithPictures:
            return EventPlaceWithPicturesCell.Constants.nib
        case .organizer:
            return EventOrganizerCell.Constants.nib
        case .team:
            return EventTeamsCell.Constants.nib
        case .myGuests:
            return EventMyGuestsCell.Constants.nib
        }
    }
        
    var estimatedCellHeight: CGFloat {
        switch self {
        case .title:
            return EventTitleCell.Constants.height
        case .desc:
            return EventDescriptionCell.Constants.height
        case .dateAndHour:
            return EventDateAndHourCell.Constants.height
        case .place:
            return EventPlaceCell.Constants.height
        case .placeWithPictures:
            return EventPlaceWithPicturesCell.Constants.height
        case .organizer:
            return EventOrganizerCell.Constants.height
        case .team:
            return EventTeamsCell.Constants.height
        case .myGuests:
            return EventMyGuestsCell.Constants.height
        }
    }
    
    static let all: [MEventSectionAsParticipant] = [.title,
                                                    .desc,
                                                    .dateAndHour,
                                                    .place,
                                                    .placeWithPictures,
                                                    .organizer,
                                                    .team,
                                                    .myGuests]
}
