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
                "id": user.uid
            ]
            FFirestoreReference.users.document(user.uid).setData(data, merge: true)
        }
    }
    
    static func setFavoriteSports(favoriteSports: [FavoriteSport]) {
        guard let user = Auth.auth().currentUser else { return }
        for favoriteSport in favoriteSports {
            if let favoriteSportId = favoriteSport.id {
                FFirestoreReference.userFavoriteSports(user.uid).document(favoriteSportId).setData(favoriteSport.toData, merge: true)
            }
        }
    }
    
    // MARK: get
    static func getProfile(completion: @escaping (User?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        FFirestoreReference.users.document(user.uid).getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data(),
                  let user = try? FirebaseDecoder().decode(User.self, from: data) else {
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
                   let event = try? FirebaseDecoder().decode(RelatedEvent.self, from: document.data()) {
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
                   let event = try? FirebaseDecoder().decode(RelatedEvent.self, from: document.data()) {
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
                if let favoriteSport = try? FirebaseDecoder().decode(FavoriteSport.self, from: document.data()) {
                    favoriteSports.append(favoriteSport)
                }
            }
            completion(favoriteSports)
        }
    }
}
