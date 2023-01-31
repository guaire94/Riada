//
//  ServiceUser.swift
//  Riada
//
//  Created by Quentin Gallois on 21/10/2020.
//

import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

protocol ServiceUserEventsDelegate {
    func dataAdded(event: RelatedEvent)
    func dataModified(event: RelatedEvent)
    func dataRemoved(event: RelatedEvent)
    func didFinishLoading()
}

protocol ServiceUserNotificationDelegate {
    func dataAdded(notification: Notification)
    func dataModified(notification: Notification)
    func dataRemoved(notification: Notification)
    func didFinishLoading()
}

class ServiceUser {
    
    // MARK: - Properties
    private static var eventsListener: ListenerRegistration?
    private static var notificationsListener: ListenerRegistration?

    // MARK: Set
    static func signUpAnonymously() {
        Auth.auth().signInAnonymously { (_, _) in
            guard let user = Auth.auth().currentUser else { return }
            let data: [String : Any] = [
                "favoritesSports": [],
                "createdDate": Timestamp()
            ]
            FFirestoreReference.users.document(user.uid).setData(data, merge: true)
        }
    }
    
    static func signInWithCredential(credential: AuthCredential, completion: @escaping () -> Void) {
        Auth.auth().signIn(with: credential) { _, _ in
            completion()
        }
    }
    
    static func linkAccount(credential: AuthCredential, completion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        user.link(with: credential) { (authResult, error) in
            if let _ = error {
                signInWithCredential(credential: credential, completion: completion)
            } else {
                completion()
            }
        }
    }
    
    static func updateLocation(city: City) {
        guard let user = Auth.auth().currentUser else { return }
        let data: [String : Any] = [
            "location": city.geoPoint
        ]
        FFirestoreReference.users.document(user.uid).setData(data, merge: true)
    }
    
    static func updateNickName(nickName: String) {
        guard let user = Auth.auth().currentUser else { return }
        let data: [String : Any] = [
            "nickName": nickName
        ]        
        FFirestoreReference.users.document(user.uid).setData(data, merge: true)
        
        // related User
        let relatedUserData: [String : Any] = [
            "userNickName": nickName
        ]
        for collectionGroup in FFireStoreCollectionGroup.relatedUser(userId: user.uid) {
            collectionGroup.getDocuments { (snapshot, err) in
                guard err == nil, let documents = snapshot?.documents else { return }
                documents.forEach { $0.reference.setData(relatedUserData, merge: true) }
            }
        }
        
        // related Guest
        let relatedGuestData: [String : Any] = [
            "associatedUserNickName": nickName
        ]
        for collectionGroup in FFireStoreCollectionGroup.relatedGuest(userId: user.uid) {
            collectionGroup.getDocuments { (snapshot, err) in
                guard err == nil, let documents = snapshot?.documents else { return }
                documents.forEach { $0.reference.setData(relatedGuestData, merge: true) }
            }
        }
    }
    
    static func updateAvatar(avatarUrl: String) {
        guard let user = Auth.auth().currentUser else { return }
        let data: [String : Any] = [
            "avatar": avatarUrl
        ]
        FFirestoreReference.users.document(user.uid).setData(data, merge: true)
        
        // related User
        let relatedUserData: [String : Any] = [
            "userAvatar": avatarUrl
        ]
        for collectionGroup in FFireStoreCollectionGroup.relatedUser(userId: user.uid) {
            collectionGroup.getDocuments { (snapshot, err) in
                guard err == nil, let documents = snapshot?.documents else { return }
                documents.forEach { $0.reference.setData(relatedUserData, merge: true) }
            }
        }
        
        // related Guest
        let relatedGuestData: [String : Any] = [
            "associatedUserAvatar": avatarUrl
        ]
        for collectionGroup in FFireStoreCollectionGroup.relatedGuest(userId: user.uid) {
            collectionGroup.getDocuments { (snapshot, err) in
                guard err == nil, let documents = snapshot?.documents else { return }
                documents.forEach { $0.reference.setData(relatedGuestData, merge: true) }
            }
        }
    }
    
    static func updateFavoriteSports(favoriteSportIds: [String]) {
        guard let user = Auth.auth().currentUser else { return }
        let data = ["favoritesSports": favoriteSportIds]
        FFirestoreReference.users.document(user.uid).setData(data, merge: true)
    }
    
    // MARK: - Get
    static func getProfile(completion: @escaping (User?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        FFirestoreReference.users.document(user.uid).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let user = try? document.data(as: User.self) else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
    
    static func getNotifications(delegate: ServiceUserNotificationDelegate) {
        guard let userId = ManagerUser.shared.userId else { return }
        
        notificationsListener?.remove()
        notificationsListener = FFirestoreReference.userNotifications(userId).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.didFinishLoading()
            }
            snapshot.documentChanges.forEach { diff in
                if let notification = try? diff.document.data(as: Notification.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(notification: notification)
                    case .modified:
                        delegate.dataModified(notification: notification)
                    case .removed:
                        delegate.dataRemoved(notification: notification)
                    }
                }
                numberOfItems -= 1
                if numberOfItems == .zero {
                    delegate.didFinishLoading()
                }
            }
        }
    }
    
    static func getOrganizeEvents(delegate: ServiceUserEventsDelegate) {
        guard let userId = ManagerUser.shared.userId else { return }

        eventsListener?.remove()
        eventsListener = FFirestoreReference.userOrganizeEvents(userId).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.didFinishLoading()
            }
            snapshot.documentChanges.forEach { diff in
                if let event = try? diff.document.data(as: RelatedEvent.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(event: event)
                    case .modified:
                        delegate.dataModified(event: event)
                    case .removed:
                        delegate.dataRemoved(event: event)
                    }
                }
                numberOfItems -= 1
                if numberOfItems == .zero {
                    delegate.didFinishLoading()
                }
            }
        }
    }
    
    static func getParticipateEvents(delegate: ServiceUserEventsDelegate) {
        guard let userId = ManagerUser.shared.userId else { return }

        eventsListener?.remove()
        eventsListener = FFirestoreReference.userParticipateEvents(userId).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.didFinishLoading()
            }
            snapshot.documentChanges.forEach { diff in
                if let event = try? diff.document.data(as: RelatedEvent.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(event: event)
                    case .modified:
                        delegate.dataModified(event: event)
                    case .removed:
                        delegate.dataRemoved(event: event)
                    }
                }
                numberOfItems -= 1
                if numberOfItems == .zero {
                    delegate.didFinishLoading()
                }
            }
        }
    }
    
    static func getOtherProfile(userId: String, completion: @escaping (User?) -> Void) {
        FFirestoreReference.users.document(userId).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let user = try? document.data(as: User.self) else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
    
    static func getOtherProfileOrganizeEvents(userId: String, delegate: ServiceUserEventsDelegate) {
        eventsListener?.remove()
        eventsListener = FFirestoreReference.userOrganizeEvents(userId).whereField("isPrivate", isEqualTo: false).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.didFinishLoading()
            }
            snapshot.documentChanges.forEach { diff in
                if let event = try? diff.document.data(as: RelatedEvent.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(event: event)
                    case .modified:
                        delegate.dataModified(event: event)
                    case .removed:
                        delegate.dataRemoved(event: event)
                    }
                }
                numberOfItems -= 1
                if numberOfItems == .zero {
                    delegate.didFinishLoading()
                }
            }
        }
    }
    
    static func getOtherProfileParticipateEvents(userId: String, delegate: ServiceUserEventsDelegate) {
        eventsListener?.remove()
        eventsListener = FFirestoreReference.userParticipateEvents(userId).whereField("isPrivate", isEqualTo: false).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.didFinishLoading()
            }
            snapshot.documentChanges.forEach { diff in
                if let event = try? diff.document.data(as: RelatedEvent.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(event: event)
                    case .modified:
                        delegate.dataModified(event: event)
                    case .removed:
                        delegate.dataRemoved(event: event)
                    }
                }
                numberOfItems -= 1
                if numberOfItems == .zero {
                    delegate.didFinishLoading()
                }
            }
        }
    }
    
    static func getUserByFavoriteSport(event: Event, completion: @escaping ([User]) -> Void) {
        guard let userId = ManagerUser.shared.userId else { return }

        let lat = event.placeCoordinate.latitude
        let lng = event.placeCoordinate.longitude
        
        let lesserGeopoint = HelperDistance.shared.computeLesserGeoPoint(lat: lat, lng: lng)
        let greaterGeopoint = HelperDistance.shared.computeGreatestGeoPoint(lat: lat, lng: lng)

            FFirestoreReference.users.order(by: "location").whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint).getDocuments { (querySnapshot, err) in
                var users: [User] = []
                guard err == nil, let documents = querySnapshot?.documents else {
                    completion(users)
                    return
                }
                for document in documents {
                    if document.exists,
                       let user = try? document.data(as: User.self),
                       user.id != userId,
                       let favoritesSports = user.favoritesSports,
                       favoritesSports.contains(event.sportId) {
                        users.append(user)
                    }
                }
                completion(users)
            }
    }

    static func getNbEventOrganized(userId: String, completion: @escaping (Int?) -> Void) {
        FFirestoreReference.userOrganizeEvents(userId).getDocuments { (snapshot, err) in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            completion(snapshot.count)
        }
    }

    static func getNbEventPlayed(userId: String, completion: @escaping (Int?) -> Void) {
        FFirestoreReference.userParticipateEvents(userId).getDocuments { (snapshot, err) in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            completion(snapshot.count)
        }
    }

}
