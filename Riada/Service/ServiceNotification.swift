//
//  ServiceNotification.swift
//  Riada
//
//  Created by P995987 on 12/12/2020.
//

import Firebase
import FirebaseMessaging
import FirebaseFirestore

class ServiceNotification {
    
    static var functions = Functions.functions()
    
    // MARK: - Organiser
    static func organize(event: Event) {
        guard let nickName = ManagerUser.shared.user?.nickName,
            let eventId = event.id else {
            return
        }
        ServiceUser.getUserByFavoriteSport(event: event) { users in
            for user in users {
                guard let userId = user.id else { return }
                let type: MNotificationType = .organize
                let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
                let data: [String : Any] = [
                            "title_loc_key": type.title,
                            "title_loc_args": [event.sportEmoticon, event.title, event.description],
                            "body_loc_key": type.body,
                            "body_loc_args": [nickName],
                            "deeplink": deeplink,
                            "createdDate": Timestamp()]
                FFirestoreReference.userNotifications(userId).addDocument(data: data)
            }
        }
    }
    
    static func acceptYourParticipation(event: Event, participant: Participant) {
        guard let eventId = event.id else { return }

        let type: MNotificationType = .acceptYourParticipation
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(participant.userId).addDocument(data: data)
    }
    
    static func acceptNewParticipation(event: Event, participants: [Participant], joiner: Participant) {
        guard let eventId = event.id, let userId = ManagerUser.shared.userId else { return }

        let type: MNotificationType = .acceptNewParticipation
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        
        for participant in participants {
            guard participant.userId != userId else { continue }
            let data: [String : Any] = [
                        "env": Config.firebaseEnv,
                        "title_loc_key": type.title,
                        "title_loc_args": [event.sportEmoticon, event.title, event.description],
                        "body_loc_key": type.body,
                        "body_loc_args": [joiner.userNickName],
                        "deeplink": deeplink,
                        "createdDate": Timestamp()]

            FFirestoreReference.userNotifications(participant.userId).addDocument(data: data)
        }
    }
    
    static func acceptYourGuest(event: Event, guest: Guest) {
        guard let eventId = event.id else { return }

        let type: MNotificationType = .acceptYourGuest
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(guest.associatedUserId).addDocument(data: data)
    }
    
    static func acceptNewGuest(event: Event, participants: [Participant], joiner: Guest) {
        guard let eventId = event.id, let userId = ManagerUser.shared.userId else { return }

        let type: MNotificationType = .acceptNewGuest
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        
        for participant in participants {
            guard participant.userId != userId else { continue }

            let data: [String : Any] = [
                        "env": Config.firebaseEnv,
                        "title_loc_key": type.title,
                        "title_loc_args": [event.sportEmoticon, event.title, event.description],
                        "body_loc_key": type.body,
                        "body_loc_args": [joiner.associatedUserNickName],
                        "deeplink": deeplink,
                        "createdDate": Timestamp()]

            FFirestoreReference.userNotifications(participant.userId).addDocument(data: data)
        }
    }
    
    static func refuseYourParticipation(event: Event, participant: Participant) {
        guard let eventId = event.id else { return }

        let type: MNotificationType = .refuseYourParticipation
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(participant.userId).addDocument(data: data)
    }
    
    static func refuseYourGuest(event: Event, guest: Guest) {
        guard let eventId = event.id else { return }

        let type: MNotificationType = .refuseYourGuest
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(guest.associatedUserId).addDocument(data: data)
    }
    
    static func editEvent(event: Event, participants: [Participant]) {
        guard let nickName = ManagerUser.shared.user?.nickName,
            let eventId = event.id else {
            return
        }

        let type: MNotificationType = .editEvent
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        
        for participant in participants {
            let data: [String : Any] = [
                        "env": Config.firebaseEnv,
                        "title_loc_key": type.title,
                        "title_loc_args": [event.sportEmoticon, event.title, event.description],
                        "body_loc_key": type.body,
                        "body_loc_args": [nickName],
                        "deeplink": deeplink,
                        "createdDate": Timestamp()]

            FFirestoreReference.userNotifications(participant.userId).addDocument(data: data)
        }
    }
    
    static func cancelEvent(event: Event, participants: [Participant]) {
        guard let eventId = event.id else { return }

        let type: MNotificationType = .cancelEvent
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        
        for participant in participants {
            let data: [String : Any] = [
                        "env": Config.firebaseEnv,
                        "title_loc_key": type.title,
                        "title_loc_args": [event.sportEmoticon, event.title, event.description],
                        "body_loc_key": type.body,
                        "body_loc_args": [],
                        "deeplink": deeplink,
                        "createdDate": Timestamp()]

            FFirestoreReference.userNotifications(participant.userId).addDocument(data: data)
        }
    }
    
    // MARK: - Participant
    static func participate(event: Event, organizer: Organizer) {
        guard let nickName = ManagerUser.shared.user?.nickName,
            let eventId = event.id else {
            return
        }

        let type: MNotificationType = .participate
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [nickName],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(organizer.userId).addDocument(data: data)
    }
    
    static func decline(event: Event, organizer: Organizer) {
        guard let nickName = ManagerUser.shared.user?.nickName,
            let eventId = event.id else {
            return
        }

        let type: MNotificationType = .decline
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [nickName],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(organizer.userId).addDocument(data: data)
    }
    
    static func addGuest(event: Event, organizer: Organizer) {
        guard let nickName = ManagerUser.shared.user?.nickName,
            let eventId = event.id else {
            return
        }

        let type: MNotificationType = .addGuest
        let deeplink = ManagerDeepLink.shared.createDeeplinkFrom(eventId: eventId)
        let data: [String : Any] = [
                    "env": Config.firebaseEnv,
                    "title_loc_key": type.title,
                    "title_loc_args": [event.sportEmoticon, event.title, event.description],
                    "body_loc_key": type.body,
                    "body_loc_args": [nickName],
                    "deeplink": deeplink,
                    "createdDate": Timestamp()]

        FFirestoreReference.userNotifications(organizer.userId).addDocument(data: data)
    }
}
