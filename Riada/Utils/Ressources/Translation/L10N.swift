//
//  L10N.swift
//  Riada
//
//  Created by Quentin Gallois on 20/10/2020.
//

import Foundation

struct L10N {
    
    struct global {
        struct action {
            static let ok: String = NSLocalizedString("GLOBAL_ACTION_OK", comment: "")
            static let cancel: String = NSLocalizedString("GLOBAL_ACTION_CANCEL", comment: "")
            static let confirm: String = NSLocalizedString("GLOBAL_ACTION_CONFIRM", comment: "")
        }
    }
    
    struct onBoarding {
        static let title: String = NSLocalizedString("ONBOARDING_TITLE", comment: "")
        static let appDescription: String = NSLocalizedString("ONBOARDING_APP_DESCRIPTION", comment: "")
        static let favoriteSportDescription: String = NSLocalizedString("ONBOARDING_FAVORITE_SPORT_DESCRIPTION", comment: "")
        static let letsPlay: String = NSLocalizedString("ONBOARDING_LETS_PLAY", comment: "")
    }
    
    struct searchLocation {
        static let text: String = NSLocalizedString("SEARCH_LOCATION_TEXT", comment: "")
        static let placeHolder: String = NSLocalizedString("SEARCH_LOCATION_PLACEHOLDER", comment: "")
    }
    
    struct event {
        static let nbAcceptedPlayer: String = NSLocalizedString("EVENT_NB_ACCEPTED_PLAYER", comment: "")
        static let emptyPlaceHolder: String = NSLocalizedString("EVENT_EMPTY_PLACEHOLDER", comment: "")
        struct details {
            static let organizer: String = NSLocalizedString("EVENT_DETAILS_ORGANIZER", comment: "")
            static let informations: String = NSLocalizedString("EVENT_DETAILS_INFORMATIONS", comment: "")
            static let place: String = NSLocalizedString("EVENT_DETAILS_PLACE", comment: "")
            static let photos: String = NSLocalizedString("EVENT_DETAILS_PHOTOS", comment: "")
            static let currentUserParticipate: String = NSLocalizedString("EVENT_DETAILS_CURRENT_USER_PARTICIPATE", comment: "")
            static let guestBy: String = NSLocalizedString("EVENT_DETAILS_GUEST_BY", comment: "")
            static let participants: String = NSLocalizedString("EVENT_DETAILS_PARTICIPANTS", comment: "")
            struct buttons {
                static let participate: String = NSLocalizedString("EVENT_DETAILS_BUTTONS_PARTICIPATE", comment: "")
                static let addGuest: String = NSLocalizedString("EVENT_DETAILS_BUTTONS_ADD_GUEST", comment: "")
                static let decline: String = NSLocalizedString("EVENT_DETAILS_BUTTONS_DECLINE", comment: "")
            }
            
            struct participationStatus {
                static let accepted: String = NSLocalizedString("EVENT_DETAILS_PARTICIPATION_STATUS_ACCEPTED", comment: "")
                static let refused: String = NSLocalizedString("EVENT_DETAILS_PARTICIPATION_STATUS_REFUSED", comment: "")
                static let declined: String = NSLocalizedString("EVENT_DETAILS_PARTICIPATION_STATUS_DECLINED", comment: "")
                static let pending: String = NSLocalizedString("EVENT_DETAILS_PARTICIPATION_STATUS_PENDING", comment: "")
            }
            
            struct participate {
                struct nickName {
                    static let text: String = NSLocalizedString("EVENT_DETAILS_PARTICIPATE_NICKNAME_TEXT", comment: "")
                    static let placeHolder: String = NSLocalizedString("EVENT_DETAILS_PARTICIPATE_NICKNAME_PLACEHOLDER", comment: "")
                }
            }
            struct addGuest {
                struct nickName {
                    static let text: String = NSLocalizedString("EVENT_DETAILS_ADD_GUEST_NICKNAME_TEXT", comment: "")
                    static let placeHolder: String = NSLocalizedString("EVENT_DETAILS_ADD_GUEST_NICKNAME_PLACEHOLDER", comment: "")
                }
            }
            
            struct addToCalendar {
                struct error {
                    static let title: String = NSLocalizedString("EVENT_DETAILS_ADD_TO_CALENDAR_ERROR_TITLE", comment: "")
                    static let message: String = NSLocalizedString("EVENT_DETAILS_ADD_TO_CALENDAR_ERROR_MESSAGE", comment: "")
                }
            }

        }
    }
    
    struct version {
        static let new: String = NSLocalizedString("VERSION_NEW", comment: "")
        static let available: String = NSLocalizedString("VERSION_AVAILABLE", comment: "")
        static let redirectAppStore: String = NSLocalizedString("VERSION_REDIRECT_APPSTORE", comment: "")
        static let updateLater: String = NSLocalizedString("VERSION_UPDATE_LATER", comment: "")
    }
}
