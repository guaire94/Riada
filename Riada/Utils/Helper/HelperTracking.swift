//
//  HelperTracking.swift
//  Riada
//
//  Created by Guaire94 on 14/11/2021.
//

import FirebaseAnalytics

class HelperTracking {
    
    static func track(item: Tracking) {
        #if !DEBUG
        let values = item.values
        Analytics.logEvent(values.name, parameters: values.parameters)
        #endif
    }
}

enum Tracking {
    
    // MARK: - Constants
    private enum Constants {
        static let title = "title"
        static let message = "message"
        static let name = "name"
        static let url = "url"
    }
    
    // MARK: - Alert
    case alertError(title: String, message: String)
    
    // MARK: - Tracking consent
    case trackingConsentAuthorized
    case trackingConsentRejected
    
    // MARK: - Welcome
    case welcomeAddFavoriteSport(sportName: String)
    case welcomeRemoveFavoriteSport(sportName: String)
    case welcomeLetsPlay

    // MARK: Home
    case home
    case homeSearchCity
    case homeNotifications
    case homeProfile
    case homeAddFavoriteSport(sportName: String)
    case homeRemoveFavoriteSport(sportName: String)
    case homeOrganizeEvent

    // MARK: Events
    case events(sportName: String)
    case eventsOrganizeEvent

    // MARK: Event Details
    case eventDetails
    case eventDetailsShare
    case eventDetailsOrganizer
    case eventDetailsAddToCalendar
    case eventDetailsGoTo
    case eventDetailsParticipant
    case eventDetailsGuest
    case eventDetailsParticipate
    case eventDetailsAddGuest
    case eventDetailsDecline
    case eventDetailsEdit

    // MARK: Participate
    case participateAddNickname

    // MARK: Guest
    case guestAddNickname

    // MARK: Organize
    case organizeCreateEvent
    
    // MARK: Participant
    case participantProfile
    case participantAccept
    case participantRefuse

    // MARK: Guest
    case guestProfile
    case guestAccept
    case guestRefuse

    // MARK: Edit Event
    case editEventCancel
    case editEventSave

    // MARK: SignUp
    case signUpWithNickname
    case signUpWithGoogle
    case signUpWithApple

    // MARK: MyProfile
    case myProfileOrganizerEventDetails
    case myProfileParticipateEventDetails
    case myProfileSettings
    case myProfileOrganizeEvent
    case myProfileSaveInformation
    
    // MARK: OtherProfile
    case otherProfileOrganizerEventDetails
    case otherProfileParticipateEventDetails

    // MARK: Notifications
    case notifications

    // MARK: Settings
    case settingsNotifications
    case settingsRateApp
    case settingsContactUs
    case settingsPrivacyPolicy
    case settingsTermsAndConditions
    case settingsLogout

    // MARK: Temporary
    case openDeeplinkTest(url: String)
    case openDeeplinkSuccess(url: String)

    // MARK: - Property
    var values: (name: String, parameters: [String : Any]?) {
        switch self {
        case let .alertError(title, message):
            let parameters: [String: Any] = [
                Constants.title: title,
                Constants.message: message
            ]
            return ("AlertError", parameters)
            
        case .trackingConsentAuthorized:
            return ("TrackingConsentAuthorized", nil)
        case .trackingConsentRejected:
            return ("TrackingConsentRejected", nil)

        // MARK: Welcome
        case let .welcomeAddFavoriteSport(sportName):
            let parameters: [String: Any] = [
                Constants.name: sportName
            ]
            return ("WelcomeAddFavoriteSport", parameters)
        case let .welcomeRemoveFavoriteSport(sportName):
            let parameters: [String: Any] = [
                Constants.name: sportName
            ]
            return ("WelcomeRemoveFavoriteSport", parameters)
        case .welcomeLetsPlay:
            return ("WelcomeLetsPlay", nil)
            
        // MARK: Home
        case .home:
            return ("Home", nil)
        case .homeSearchCity:
            return ("HomeSearchCity", nil)
        case .homeNotifications:
            return ("HomeNotifications", nil)
        case .homeProfile:
            return ("HomeProfile", nil)
        case let .homeAddFavoriteSport(sportName):
            let parameters: [String: Any] = [
                Constants.name: sportName
            ]
            return ("HomeAddFavoriteSport", parameters)
        case let .homeRemoveFavoriteSport(sportName):
            let parameters: [String: Any] = [
                Constants.name: sportName
            ]
            return ("HomeRemoveFavoriteSport", parameters)
        case .homeOrganizeEvent:
            return ("HomeOrganizeEvent", nil)
            
        // MARK: Events
        case let .events(sportName):
            let parameters: [String: Any] = [
                Constants.name: sportName
            ]
            return ("Events", parameters)
        case .eventsOrganizeEvent:
            return ("EventsOrganizeEvent", nil)
            
        // MARK: Events Details
        case .eventDetails:
            return ("EventDetails", nil)
        case .eventDetailsShare:
            return ("EventDetailsShare", nil)
        case .eventDetailsOrganizer:
            return ("EventDetailsOrganizer", nil)
        case .eventDetailsAddToCalendar:
            return ("EventDetailsAddToCalendar", nil)
        case .eventDetailsGoTo:
            return ("EventDetailsGoTo", nil)
        case .eventDetailsParticipant:
            return ("EventDetailsParticipant", nil)
        case .eventDetailsGuest:
            return ("EventDetailsGuest", nil)
        case .eventDetailsParticipate:
            return ("EventDetailsParticipate", nil)
        case .eventDetailsAddGuest:
            return ("EventDetailsAddGuest", nil)
        case .eventDetailsDecline:
            return ("EventDetailsDecline", nil)
        case .eventDetailsEdit:
            return ("EventDetailsEdit", nil)

        // MARK: Participate
        case .participateAddNickname:
            return ("ParticipateAddNickname", nil)
            
        // MARK: Guest
        case .guestAddNickname:
            return ("GuestAddNickname", nil)
            
        // MARK: Organize
        case .organizeCreateEvent:
            return ("OrganizeCreateEvent", nil)

        // MARK: Participant
        case .participantProfile:
            return ("ParticipantProfile", nil)
        case .participantAccept:
            return ("ParticipantAccept", nil)
        case .participantRefuse:
            return ("ParticipantRefuse", nil)
            
        // MARK: Guest
        case .guestProfile:
            return ("GuestProfile", nil)
        case .guestAccept:
            return ("GuestAccept", nil)
        case .guestRefuse:
            return ("GuestRefuse", nil)
            
        // MARK: Edit Event
        case .editEventCancel:
            return ("EditEventCancel", nil)
        case .editEventSave:
            return ("EditEventSave", nil)

        // MARK: SignUp
        case .signUpWithNickname:
            return ("SignUpWithNickname", nil)
        case .signUpWithGoogle:
            return ("SignUpWithGoogle", nil)
        case .signUpWithApple:
            return ("SignUpWithApple", nil)
            
        // MARK: MyProfile
        case .myProfileOrganizerEventDetails:
            return ("MyProfileOrganizerEventDetails", nil)
        case .myProfileParticipateEventDetails:
            return ("MyProfileParticipateEventDetails", nil)
        case .myProfileSettings:
            return ("MyProfileSettings", nil)
        case .myProfileOrganizeEvent:
            return ("MyProfileOrganizeEvent", nil)
        case .myProfileSaveInformation:
            return ("MyProfileSaveInformation", nil)
            
        // MARK: OtherProfile
        case .otherProfileOrganizerEventDetails:
            return ("OtherProfileOrganizerEventDetails", nil)
        case .otherProfileParticipateEventDetails:
            return ("OtherProfileParticipateEventDetails", nil)
        
        // MARK: Notifications
        case .notifications:
            return ("Notifications", nil)
            
        // MARK: Settings
        case .settingsNotifications:
            return ("SettingsNotifications", nil)
        case .settingsRateApp:
            return ("SettingsRateApp", nil)
        case .settingsContactUs:
            return ("SettingsContactUs", nil)
        case .settingsPrivacyPolicy:
            return ("SettingsPrivacyPolicy", nil)
        case .settingsTermsAndConditions:
            return ("SettingsTermsAndConditions", nil)
        case .settingsLogout:
            return ("SettingsLogout", nil)
            
        // MARK: - Temporary
        case let .openDeeplinkTest(url):
            let parameters: [String: Any] = [
                Constants.url: url
            ]
            return ("OpenDeeplinkTest", parameters)
        case let .openDeeplinkSuccess(url):
            let parameters: [String: Any] = [
                Constants.url: url
            ]
            return ("OpenDeeplinkSuccess", parameters)
        }
    }
}
