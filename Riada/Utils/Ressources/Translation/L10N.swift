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
        struct city {
            static let text: String = NSLocalizedString("SEARCH_LOCATION_CITY_TEXT", comment: "")
            static let placeHolder: String = NSLocalizedString("SEARCH_LOCATION_CITY_PLACEHOLDER", comment: "")
        }
        struct place {
            static let text: String = NSLocalizedString("SEARCH_LOCATION_PLACE_TEXT", comment: "")
            static let placeHolder: String = NSLocalizedString("SEARCH_LOCATION_PLACE_PLACEHOLDER", comment: "")
        }
    }
    
    struct event {
        static let nbPlayer: String = NSLocalizedString("EVENT_NB_PLAYER", comment: "")
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
                static let edit: String = NSLocalizedString("EVENT_DETAILS_BUTTONS_EDIT", comment: "")
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
            struct goTo {
                static let title: String = NSLocalizedString("EVENT_DETAILS_GO_TO_TITLE", comment: "")
                static let waze: String = NSLocalizedString("EVENT_DETAILS_GO_TO_WAZE", comment: "")
                static let gmaps: String = NSLocalizedString("EVENT_DETAILS_GO_TO_GMAPS", comment: "")
                static let plan: String = NSLocalizedString("EVENT_DETAILS_GO_TO_PLAN", comment: "")
                static let notNecessary: String = NSLocalizedString("EVENT_DETAILS_GO_TO_NOT_NECESSARY", comment: "")
            }
        }
        struct organize {
            static let title: String = NSLocalizedString("EVENT_ORGANIZE_TITLE", comment: "")
            struct form {
                static let sport: String = NSLocalizedString("EVENT_ORGANIZE_FORM_SPORT", comment: "")
                static let title: String = NSLocalizedString("EVENT_ORGANIZE_FORM_TITLE", comment: "")
                static let titlePlaceHolder: String = NSLocalizedString("EVENT_ORGANIZE_FORM_TITLE_PLACEHOLDER", comment: "")
                static let desc: String = NSLocalizedString("EVENT_ORGANIZE_FORM_DESC", comment: "")
                static let descPlaceHolder: String = NSLocalizedString("EVENT_ORGANIZE_FORM_DESC_PLACEHOLDER", comment: "")
                static let dateAndHour: String = NSLocalizedString("EVENT_ORGANIZE_FORM_DATE_AND_HOUR", comment: "")
                static let address: String = NSLocalizedString("EVENT_ORGANIZE_FORM_ADDRESS", comment: "")
                static let nbPlayers: String = NSLocalizedString("EVENT_ORGANIZE_FORM_NB_PLAYERS", comment: "")
                static let isParticipate: String = NSLocalizedString("EVENT_ORGANIZE_FORM_IS_PARTICIPATE", comment: "")
                static let isPrivate: String = NSLocalizedString("EVENT_ORGANIZE_FORM_IS_PRIVATE", comment: "")
                static let createEvent: String = NSLocalizedString("EVENT_ORGANIZE_FORM_CREATE_EVENT", comment: "")
                
                struct error {
                   static let unfill: String = NSLocalizedString("EVENT_ORGANIZE_FORM_ERROR_UNFILL", comment: "")
               }
            }
        }
        
        struct edit {
            static let title: String = NSLocalizedString("EVENT_EDIT_TITLE", comment: "")
            struct form {
                static let saveEvent: String = NSLocalizedString("EVENT_EDIT_FORM_SAVE_EVENT", comment: "")
                static let cancelEvent: String = NSLocalizedString("EVENT_EDIT_FORM_CANCEL_EVENT", comment: "")
                static let cancelMessageEvent: String = NSLocalizedString("EVENT_EDIT_FORM_CANCEL_MESSAGE_EVENT", comment: "")

                struct error {
                   static let unfill: String = NSLocalizedString("EVENT_EDIT_FORM_ERROR_UNFILL", comment: "")
               }
            }
        }
    }
    
    struct signUp {
        static let welcome: String = NSLocalizedString("SIGNUP_WELCOME", comment: "")
        static let anonymously: String = NSLocalizedString("SIGNUP_ANONYMOUSLY", comment: "")
        static let signIn: String = NSLocalizedString("SIGNUP_SIGNIN", comment: "")
        static let signInWithApple: String = NSLocalizedString("SIGNUP_SIGNIN_WITH_APPLE", comment: "")
        static let signInWithGoogle: String = NSLocalizedString("SIGNUP_SIGNIN_WITH_GOOGLE", comment: "")

        struct form {
            static let nickName: String = NSLocalizedString("SIGNUP_FORM_NICKNAME", comment: "")
            static let nickNamePlaceHolder: String = NSLocalizedString("SIGNUP_FORM_NICKNAME_PLACEHOLDER", comment: "")
            static let signUp: String = NSLocalizedString("SIGNUP_FORM_SIGNUP", comment: "")

            struct error {
               static let unfill: String = NSLocalizedString("SIGNUP_FORM_ERROR_UNFILL", comment: "")
           }
        }
        
        struct error {
            static let withApple: String = NSLocalizedString("SIGNUP_ERROR_WITH_APPLE", comment: "")
        }
    }
    
    struct profile {
        static let organizer: String = NSLocalizedString("PROFILE_ORGANIZER", comment: "")
        static let organizerEmptyPlaceHolder: String = NSLocalizedString("EVENT_ORGANIZER_EMPTY_PLACEHOLDER", comment: "")
        static let participate: String = NSLocalizedString("PROFILE_PARTICIPATE", comment: "")
        static let participateEmptyPlaceHolder: String = NSLocalizedString("EVENT_PARTICIPATE_EMPTY_PLACEHOLDER", comment: "")
        static let informations: String = NSLocalizedString("PROFILE_INFORMATIONS", comment: "")
        
        struct imagePicker {
            static let loadFromGallery: String = NSLocalizedString("PROFILE_IMAGE_PICKER_GALLERY", comment: "")
            static let takeAPhoto: String = NSLocalizedString("PROFILE_IMAGE_PICKER_TAKE_A_PHOTO", comment: "")
       }
    }
    
    struct version {
        static let new: String = NSLocalizedString("VERSION_NEW", comment: "")
        static let available: String = NSLocalizedString("VERSION_AVAILABLE", comment: "")
        static let redirectAppStore: String = NSLocalizedString("VERSION_REDIRECT_APPSTORE", comment: "")
        static let updateLater: String = NSLocalizedString("VERSION_UPDATE_LATER", comment: "")
    }
}
