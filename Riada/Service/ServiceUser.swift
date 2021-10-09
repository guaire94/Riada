//
//  ServiceUser.swift
//  Riada
//
//  Created by Quentin Gallois on 21/10/2020.
//

import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

class ServiceUser {

    // MARK: Set
    static func signUpAnonymously() {
        Auth.auth().signInAnonymously { (_, _) in
            guard let user = Auth.auth().currentUser else { return }
            let data: [String : Any] = [
                "createdDate": Timestamp()
            ]
            FFirestoreReference.users.document(user.uid).setData(data, merge: true)
        }
    }
    static func updateNickName(nickName: String) {
        guard let user = Auth.auth().currentUser else { return }
        let data: [String : Any] = [
            "nickName": nickName
        ]
        FFirestoreReference.users.document(user.uid).setData(data, merge: true)
        ManagerUser.shared.user?.nickName = nickName
    }
    
    static func addFavoriteSports(favoriteSport: FavoriteSport) {
        guard let user = Auth.auth().currentUser else { return }
        if let favoriteSportId = favoriteSport.id {
            FFirestoreReference.userFavoriteSports(user.uid).document(favoriteSportId).setData(favoriteSport.toData, merge: true)
        }
    }
    
    static func removeFavoriteSports(favoriteSport: FavoriteSport) {
        guard let user = Auth.auth().currentUser else { return }
        if let favoriteSportId = favoriteSport.id {
            FFirestoreReference.userFavoriteSports(user.uid).document(favoriteSportId).delete()
        }
    }
    
    // MARK: get
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
    
    static func getOrganizeEvents(completion: @escaping ([RelatedEvent]) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion([])
            return
        }
        FFirestoreReference.userOrganizeEvents(user.uid).getDocuments() { (querySnapshot, err) in
            var events: [RelatedEvent] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(events)
                return
            }
            for document in documents {
                if document.exists,
                   let event = try? document.data(as: RelatedEvent.self) {
                    events.append(event)
                }
            }
            completion(events)
        }
    }
    
    static func getParticipateEvents(completion: @escaping ([RelatedEvent]) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion([])
            return
        }
        FFirestoreReference.userParticipateEvents(user.uid).getDocuments() { (querySnapshot, err) in
            var events: [RelatedEvent] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(events)
                return
            }
            for document in documents {
                if document.exists,
                   let event = try? document.data(as: RelatedEvent.self) {
                    events.append(event)
                }
            }
            completion(events)
        }
    }
    
    static func getFavoriteSports(completion: @escaping ([FavoriteSport]) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion([])
            return
        }
        FFirestoreReference.userFavoriteSports(user.uid).getDocuments() { (querySnapshot, err) in
            var favoriteSports: [FavoriteSport] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(favoriteSports)
                return
            }
            for document in documents {
                if let favoriteSport = try? document.data(as: FavoriteSport.self) {
                    favoriteSports.append(favoriteSport)
                }
            }
            completion(favoriteSports)
        }
    }
}
