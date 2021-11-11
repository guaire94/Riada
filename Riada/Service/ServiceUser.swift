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

class ServiceUser {
    
    // MARK: - Properties
    private static var eventsListener: ListenerRegistration?

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
            if let error = error, error.localizedDescription.contains("This credential is already associated with a different user account.") {
                signInWithCredential(credential: credential, completion: completion)
            } else {
                completion()
            }
        }
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
            "associatedNickName": nickName
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
            "associatedAvatar": avatarUrl
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
    
    // MARK: get
//    static func getUserByFavoriteSport(completion: @escaping ([User]) -> Void) {
//        guard let user = Auth.auth().currentUser else {
//            completion([])
//            return
//        }
//        FFirestoreReference.users.whereField("favoritesSports.favoriteSportId", isEqualTo: "SPORT_SOCCER").getDocuments { (querySnapshot, err) in
//            var users: [User] = []
//            guard err == nil, let documents = querySnapshot?.documents else {
//                completion(users)
//                return
//            }
//            for document in documents {
//                if document.exists,
//                   let event = try? document.data(as: User.self) {
//                    users.append(event)
//                }
//            }
//            completion(users)
//        }
//    }
    
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
    
    static func getOrganizeEvents(delegate: ServiceUserEventsDelegate) {
        guard let userId = ManagerUser.shared.user?.id else { return }

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
        guard let userId = ManagerUser.shared.user?.id else { return }

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
    
    static func getFavoriteSports(completion: @escaping ([FavoriteSport]) -> Void) {
        completion([])
        return
        guard let user = Auth.auth().currentUser else {
            completion([])
            return
        }
//        FFirestoreReference.userFavoriteSports(user.uid).getDocuments() { (querySnapshot, err) in
//            var favoriteSports: [FavoriteSport] = []
//            guard err == nil, let documents = querySnapshot?.documents else {
//                completion(favoriteSports)
//                return
//            }
//            for document in documents {
//                if let favoriteSport = try? document.data(as: FavoriteSport.self) {
//                    favoriteSports.append(favoriteSport)
//                }
//            }
//            completion(favoriteSports)
//        }
    }
}
