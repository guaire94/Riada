//
//  ServiceEvent.swift
//  Riada
//
//  Created by Quentin Gallois on 28/10/2020.
//

import CodableFirebase
import FirebaseFirestore
import FirebaseFunctions

class ServiceEvent {
    
//    static func getEventsByPeriod(completion: @escaping ([Event]) -> Void) {
//        guard let startDate = ManagerPeriod.shared.startDate,
//              let endDate = ManagerPeriod.shared.endDate else {
//            return
//        }
//
//        FFirestoreReference.event.whereField("date", isGreaterThan: startDate.timestamp).whereField("date", isLessThan: endDate.timestamp).order(by: "date").getDocuments() { (querySnapshot, err) in
//            var events: [Event] = []
//            guard err == nil, let documents = querySnapshot?.documents else {
//                completion(events)
//                return
//            }
//            for document in documents {
//                if let event = Event(document: document) {
//                    events.append(event)
//                }
//            }
//            completion(events)
//        }
//    }
//
//    static func getNextEvents(completion: @escaping ([Event]) -> Void) {
//        FFirestoreReference.event.order(by: "date").start(after: [Timestamp()]).getDocuments() { (querySnapshot, err) in
//            var events: [Event] = []
//            guard err == nil, let documents = querySnapshot?.documents else {
//                completion(events)
//                return
//            }
//            for document in documents {
//                if let event = Event(document: document) {
//                    events.append(event)
//                }
//            }
//            completion(events)
//        }
//    }
//
//    static func getEventDetails(eventId: String, completion: @escaping (Event?) -> Void) {
//        FFirestoreReference.event.whereField("id", isEqualTo: eventId).getDocuments() { (querySnapshot, err) in
//            guard err == nil, let document = querySnapshot?.documents.first else {
//                completion(nil)
//                return
//            }
//            completion(Event(document: document))
//        }
//    }
//
//    static func getEventOwner(eventId: String, completion: @escaping (EventOwner?) -> Void) {
//        FFirestoreReference.ownerEvent(eventId).getDocuments() { (querySnapshot, err) in
//            guard err == nil,
//                  let document = querySnapshot?.documents.first,
//                  let owner = try? FirebaseDecoder().decode(EventOwner.self, from: document.data()) else {
//                completion(nil)
//                return
//            }
//            completion(owner)
//        }
//    }
//
//    static func getEventParticipants(eventId: String, completion: @escaping ([EventParticipant]) -> Void) {
//        FFirestoreReference.participantEvent(eventId).getDocuments() { (querySnapshot, err) in
//            var participants: [EventParticipant] = []
//            guard err == nil, let documents = querySnapshot?.documents else {
//                completion(participants)
//                return
//            }
//            for document in documents {
//                if let participant = try? FirebaseDecoder().decode(EventParticipant.self, from: document.data()) {
//                    participants.append(participant)
//                }
//            }
//            completion(participants)
//        }
//    }
//
//    static func participate(event: Event, request: EventParticipant) {
//        guard let data = try? FirestoreEncoder().encode(request) else {
//            return
//        }
//        FFirestoreReference.participantEvent(event.id).document(request.coachId).setData(data, merge: true)
//    }
//
//    static func unparticipate(_ event: Event,_ participant: EventParticipant) {
//        FFirestoreReference.participantEvent(event.id).document(participant.coachId).delete()
//    }
}

//MARK: - AS OWNER
extension ServiceEvent {
//    static func refuseParticipation(_ event: Event,_ participant: EventParticipant) {
//        let data: [String : Any] = [
//            "status": ParticipationStatus.refused.rawValue,
//        ]
//        FFirestoreReference.participantEvent(event.id).document(participant.coachId).setData(data, merge: true)
//    }
//    
//    static func acceptParticipation(_ event: Event,_ participant: EventParticipant) {
//        let data: [String : Any] = [
//            "status": ParticipationStatus.validate.rawValue,
//        ]
//        FFirestoreReference.participantEvent(event.id).document(participant.coachId).setData(data, merge: true)
//    }
//    
//    static func create(event: Event) {
//        guard let coach = ManagerAuth.shared.coach,
//              let club = ManagerAuth.shared.club,
//              let clubAffiliation = ManagerAuth.shared.selectedClubAffiliation,
//              let eventData = event.toData else {
//            return
//        }
//        
//        var owner = EventOwner(clubAcronym: club.acronym,
//                               clubLogo: club.logo,
//                               coachId: coach.id,
//                               coachFullname: coach.fullname,
//                               sportId: clubAffiliation.sportId,
//                               sportName: clubAffiliation.sportName,
//                               categoryId: clubAffiliation.categoryId,
//                               categoryName: clubAffiliation.categoryName)
//        
//        if let subCategoryId = clubAffiliation.subCategoryId,
//           let subCategoryName = clubAffiliation.subCategoryName {
//            owner.subCategoryId = subCategoryId
//            owner.subCategoryName = subCategoryName
//        }
//        
//        guard let ownerData = try? FirestoreEncoder().encode(owner) else { return }
//
//        FFirestoreReference.event.document(event.id).setData(eventData)
//        FFirestoreReference.ownerEvent(event.id).document(coach.id).setData(ownerData)
//        
//        FFirestoreReference.coachEvent(coach.id, club.id).document(event.id).setData(eventData)
//    }
//    
//    static func modify(event: Event) {
//        guard let coach = ManagerAuth.shared.coach,
//              let club = ManagerAuth.shared.club,
//              let eventData = event.toData else {
//            return
//        }
//         
//        FFirestoreReference.event.document(event.id).setData(eventData, merge: true)
//        FFirestoreReference.coachEvent(coach.id, club.id).document(event.id).setData(eventData, merge: true)
//    }
//    
//    static func delete(event: Event) {
//        guard let coach = ManagerAuth.shared.coach,
//              let club = ManagerAuth.shared.club else {
//            return
//        }
//         
//        FFirestoreReference.event.document(event.id).delete()
//        FFirestoreReference.coachEvent(coach.id, club.id).document(event.id).delete()
//    }
}

