//
//  Reference.swift
//  Riada
//
//  Created by Quentin Gallois on 21/10/2020.
//

import FirebaseFirestore
import FirebaseStorage

#if DEBUG
   let firebaseEnv = "Staging"
#else
   let firebaseEnv = "Release"
#endif

let db = Firestore.firestore()

enum FirebaseCollection {
    
    // MARK: - ENV
    static var env: String = "Env"
    
    // MARK: - VERSION
    static var version: String = "Version"
        
    // MARK: - SPORT
    static var sport: String = "Sport"

    // MARK: - USER
    static var user: String = "User"
    static var organizeEvent: String = "OrganizeEvent"
    static var participateEvent: String = "ParticipateEvent"
    static var notification: String = "Notification"

    // MARK: - EVENT
    static var event: String = "Event"
    static var organizer: String = "Organizer"
    static var participant: String = "Participant"
    static var guest: String = "Guest"
}

enum FFirestoreReference {

    // MARK: - ENV
    static var env: DocumentReference {
        db.collection(FirebaseCollection.env).document(firebaseEnv)
    }
    
    // MARK: - VERSION
    static var version: DocumentReference {
        env.collection(FirebaseCollection.version).document("iOS")
    }
    
    
    // MARK: - SPORT
    static var sports: CollectionReference {
        env.collection(FirebaseCollection.sport)
    }
    
    // MARK: - USER
    static var users: CollectionReference {
        env.collection(FirebaseCollection.user)
    }
    static func userOrganizeEvents(_ userId: String) -> CollectionReference {
        users.document(userId).collection(FirebaseCollection.organizeEvent)
    }
    static func userParticipateEvents(_ userId: String) -> CollectionReference {
        users.document(userId).collection(FirebaseCollection.participateEvent)
    }
    static func userNotifications(_ userId: String) -> CollectionReference {
        users.document(userId).collection(FirebaseCollection.notification)
    }

    // MARK: - EVENT
    static var events: CollectionReference {
        env.collection(FirebaseCollection.event)
    }
    static func eventOrganizer(_ eventId: String) -> CollectionReference {
        events.document(eventId).collection(FirebaseCollection.organizer)
    }
    static func eventParticipants(_ eventId: String) -> CollectionReference {
        events.document(eventId).collection(FirebaseCollection.participant)
    }
    static func eventGuests(_ eventId: String) -> CollectionReference {
        events.document(eventId).collection(FirebaseCollection.guest)
    }
}

struct FFireStoreCollectionGroup {
    
    // MARK: - EVENT
    static func relatedEvent(eventId: String) -> [Query] {
        let collections: Set<String> = [
            FirebaseCollection.organizeEvent,
            FirebaseCollection.participateEvent,
        ]
        return collections.map { db.collectionGroup($0).whereField("eventId", isEqualTo: eventId) }
    }
    
    static func relatedUser(userId: String) -> [Query] {
        let collections: Set<String> = [
            FirebaseCollection.organizer,
            FirebaseCollection.participant,
        ]
        return collections.map { db.collectionGroup($0).whereField("userId", isEqualTo: userId) }
    }
    
    static func relatedGuest(userId: String) -> [Query] {
        [db.collectionGroup(FirebaseCollection.guest).whereField("associatedUserId", isEqualTo: userId)]
    }

}

enum FStorageReference {
    
    // MARK: - ENV
    static var env: StorageReference {
        Storage.storage().reference(withPath: FirebaseCollection.env).child(firebaseEnv)
    }
    
    // MARK: - COACH
    static func user(userId: String) -> StorageReference {
        env.child(FirebaseCollection.user).child(userId)
    }
}
