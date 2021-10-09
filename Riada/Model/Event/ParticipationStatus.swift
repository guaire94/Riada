//
//  MParticipationStatus.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import UIKit

enum ParticipationStatus: String {
    case accepted
    case pending
    case refused
    case declined
    
    var color: UIColor {
        switch self {
        case .accepted:
            return .mGreen
        case .pending:
            return .mOrange
        case .refused, .declined:
            return .mRed
        }
    }
    
    var desc: String {
        switch self {
        case .accepted:
            return L10N.event.details.participationStatus.accepted
        case .pending:
            return L10N.event.details.participationStatus.pending
        case .refused:
            return L10N.event.details.participationStatus.refused
        case .declined:
            return L10N.event.details.participationStatus.declined
        }
    }
}
