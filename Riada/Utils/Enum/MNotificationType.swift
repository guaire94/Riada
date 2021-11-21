//
//  MNotification.swift
//  Riada
//
//  Created by P995987 on 12/12/2020.
//

// TODO: Defined MNotificationType
enum MNotificationType: String {
    case organize
    case acceptYourParticipation
    case acceptNewParticipation
    case acceptYourGuest
    case acceptNewGuest
    case refuseYourParticipation
    case refuseYourGuest
    case editEvent
    case participate
    case decline
    case addGuest

    var title: String {
        switch self {
        case .organize:
            return L10N.notifications.organize.title
        case .acceptYourParticipation:
            return L10N.notifications.acceptYourParticipation.title
        case .acceptNewParticipation:
            return L10N.notifications.acceptNewParticipation.title
        case .acceptYourGuest:
            return L10N.notifications.acceptYourGuest.title
        case .acceptNewGuest:
            return L10N.notifications.acceptNewGuest.title
        case .refuseYourParticipation:
            return L10N.notifications.refuseYourParticipation.title
        case .refuseYourGuest:
            return L10N.notifications.refuseYourGuest.title
        case .editEvent:
            return L10N.notifications.editEvent.title
        case .participate:
            return L10N.notifications.participate.title
        case .decline:
            return L10N.notifications.decline.title
        case .addGuest:
            return L10N.notifications.addGuest.title
        }
    }

    var body: String {
        switch self {
        case .organize:
            return L10N.notifications.organize.body
        case .acceptYourParticipation:
            return L10N.notifications.acceptYourParticipation.body
        case .acceptNewParticipation:
            return L10N.notifications.acceptNewParticipation.body
        case .acceptYourGuest:
            return L10N.notifications.acceptYourGuest.body
        case .acceptNewGuest:
            return L10N.notifications.acceptNewGuest.body
        case .refuseYourParticipation:
            return L10N.notifications.refuseYourParticipation.body
        case .refuseYourGuest:
            return L10N.notifications.refuseYourGuest.body
        case .editEvent:
            return L10N.notifications.editEvent.body
        case .participate:
            return L10N.notifications.participate.body
        case .decline:
            return L10N.notifications.decline.body
        case .addGuest:
            return L10N.notifications.addGuest.body
        }
    }
}
