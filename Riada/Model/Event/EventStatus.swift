//
//  EventStatus.swift
//  Riada
//
//  Created by Guaire94 on 01/12/2021.
//

import UIKit

enum EventStatus: String {
    case open
    case canceled
    
    var color: UIColor? {
        switch self {
        case .open:
            return nil
        case .canceled:
            return .mRed
        }
    }
    
    var desc: String? {
        switch self {
        case .open:
            return nil
        case .canceled:
            return L10N.event.details.status.canceled
        }
    }
}
