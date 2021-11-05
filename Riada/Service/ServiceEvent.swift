//
//  ServiceEvent.swift
//  Riada
//
//  Created by Guaire94 on 16/09/2021.
//

import Firebase
import CodableFirebase
import CoreLocation
import GeoFire

protocol ServiceNextEventDelegate {
    func dataAdded(event: Event)
    func dataModified(event: Event)
    func dataRemoved(event: Event)
    func didFinishLoading()
}

protocol ServiceEventParticipantDelegate {
    func dataAdded(participant: Participant)
    func dataModified(participant: Participant)
    func dataRemoved(participant: Participant)
}

protocol ServiceEventGuestDelegate {
    func dataAdded(guest: Guest)
    func dataModified(guest: Guest)
    func dataRemoved(guest: Guest)
}

class ServiceEvent {
    
    // MARK: - Constants
    enum Constant {
        static var maxMilesDistance: Double = 20
        static var OneMileLat: Double = 0.0144927536231884
        static var OneMileLng: Double = 0.0181818181818182
    }
    
    // MARK: - Properties
    private static var nextEventsListener: ListenerRegistration?
    
    // MARK: - GET
    static func getEventDetails(eventId: String, completion: @escaping (Event?) -> Void) {
        FFirestoreReference.events.document(eventId).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let event = try? document.data(as: Event.self) else {
                completion(nil)
                return
            }
            completion(event)
        }
    }

    static func getNextEvents(sportId: String, delegate: ServiceNextEventDelegate) {
        let lat = ManagerUser.shared.currentCity.lat
        let lng = ManagerUser.shared.currentCity.lng
        
        let lowerLat = lat - (Constant.OneMileLat * Constant.maxMilesDistance)
        let lowerLon = lng - (Constant.OneMileLng * Constant.maxMilesDistance)
        
        let greaterLat = lat + (Constant.OneMileLat * Constant.maxMilesDistance)
        let greaterLon = lng + (Constant.OneMileLng * Constant.maxMilesDistance)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        
        nextEventsListener?.remove()
        nextEventsListener = FFirestoreReference.events.order(by: "placeCoordinate").whereField("placeCoordinate", isGreaterThan: lesserGeopoint).whereField("placeCoordinate", isLessThan: greaterGeopoint).whereField("sportId", isEqualTo: sportId).whereField("isPrivate", isEqualTo: false).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.didFinishLoading()
            }
            let timeStamp = Timestamp(date: Date().onlyDate)
            snapshot.documentChanges.forEach { diff in
                if let event = try? diff.document.data(as: Event.self),
                   event.date.compare(timeStamp) != .orderedAscending {
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
    
    static func getEventOrganizer(eventId: String, completion: @escaping (Organizer?) -> Void) {
        FFirestoreReference.eventOrganizer(eventId).getDocuments() { (querySnapshot, err) in
            guard err == nil,
                  let document = querySnapshot?.documents.first,
                  let organizer = try? document.data(as: Organizer.self) else {
                completion(nil)
                return
            }
            completion(organizer)
        }
    }
    
    static func getEventParticipants(eventId: String, delegate: ServiceEventParticipantDelegate) {
        FFirestoreReference.eventParticipants(eventId).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                if let participant = try? diff.document.data(as: Participant.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(participant: participant)
                    case .modified:
                        delegate.dataModified(participant: participant)
                    case .removed:
                        delegate.dataRemoved(participant: participant)
                    }
                }
            }
        }
    }
    
    static func getEventGuests(eventId: String, delegate: ServiceEventGuestDelegate) {
        FFirestoreReference.eventGuests(eventId).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                if let guest = try? diff.document.data(as: Guest.self) {
                    switch diff.type {
                    case .added:
                        delegate.dataAdded(guest: guest)
                    case .modified:
                        delegate.dataModified(guest: guest)
                    case .removed:
                        delegate.dataRemoved(guest: guest)
                    }
                }
            }
        }
    }

    // MARK: - POST
    static func create(event: Event) {
        guard let eventId = event.id,
              let eventData = event.toCreateData,
              let userId = ManagerUser.shared.user?.id,
              let organizerData = ManagerUser.shared.user?.toOrganizerData else {
            return
        }
        
        FFirestoreReference.events.document(eventId).setData(eventData, merge: false)
        FFirestoreReference.eventOrganizer(eventId).document(userId).setData(organizerData, merge: false)
    }

    // MARK: - UPDATE
    static func edit(event: Event) {
        guard let eventId = event.id,
              let eventData = event.toUpdateData,
              let userId = ManagerUser.shared.user?.id,
              let organizerData = ManagerUser.shared.user?.toOrganizerData else {
            return
        }
        
        FFirestoreReference.events.document(eventId).setData(eventData, merge: true)
        FFirestoreReference.eventOrganizer(eventId).document(userId).setData(organizerData, merge: true)
    }
    
    static func updateNbAcceptedPlayer(eventId: String, nbAcceptedPlayer: Int) {
        let eventData = ["nbAcceptedPlayer": nbAcceptedPlayer]        
        FFirestoreReference.events.document(eventId).setData(eventData, merge: true)
    }


    static func participate(eventId: String) {
        guard let userId = ManagerUser.shared.user?.id,
              let data = ManagerUser.shared.user?.toParticipantData else {
            return
        }
        
        FFirestoreReference.eventParticipants(eventId).document(userId).setData(data, merge: false)
    }
    
    static func participateAsOrganizer(eventId: String) {
        guard let userId = ManagerUser.shared.user?.id,
              let data = ManagerUser.shared.user?.toParticipantAsOrganizerData else {
            return
        }
        
        FFirestoreReference.eventParticipants(eventId).document(userId).setData(data, merge: false)
    }
    
    static func unParticipateAsOrganizer(eventId: String) {
        guard let userId = ManagerUser.shared.user?.id else { return }
        
        FFirestoreReference.eventParticipants(eventId).document(userId).delete()
    }
    
    static func addGuest(eventId: String, nickName: String, asOrganizer: Bool) {
        guard var data = ManagerUser.shared.user?.toAddGuestData else {
            return
        }
        
        data["guestNickName"] = nickName
        if asOrganizer {
            data["status"] = ParticipationStatus.accepted.rawValue
        }
        FFirestoreReference.eventGuests(eventId).document(UUID().uuidString).setData(data, merge: false)
    }
    
    static func decline(eventId: String) {
        guard let userId = ManagerUser.shared.user?.id else { return }
        let data = [
           "status": ParticipationStatus.declined.rawValue
        ]
        
        FFirestoreReference.eventParticipants(eventId).document(userId).setData(data, merge: true)
    }
    
    static func acceptParticipant(eventId: String, participant: Participant) {
        guard let participantId = participant.id else { return }
        let data = [
            "status": ParticipationStatus.accepted.rawValue
        ]
        FFirestoreReference.eventParticipants(eventId).document(participantId).setData(data, merge: true)
    }
    
    static func refuseParticipant(eventId: String, participant: Participant) {
        guard let participantId = participant.id else { return }
        let data = [
            "status": ParticipationStatus.refused.rawValue
        ]
        FFirestoreReference.eventParticipants(eventId).document(participantId).setData(data, merge: true)
    }
    
    static func acceptGuest(eventId: String, guest: Guest) {
        guard let guestId = guest.id else { return }
        let data = [
            "status": ParticipationStatus.accepted.rawValue
        ]
        FFirestoreReference.eventGuests(eventId).document(guestId).setData(data, merge: true)
    }
    
    static func refuseGuest(eventId: String, guest: Guest) {
        guard let guestId = guest.id else { return }
        let data = [
            "status": ParticipationStatus.refused.rawValue
        ]
        FFirestoreReference.eventGuests(eventId).document(guestId).setData(data, merge: true)
    }
    
    // MARK: DELETE
    static func cancel(event: Event) {
        guard let eventId = event.id,
              let userId = ManagerUser.shared.user?.id else {
            return
        }
        
        FFirestoreReference.events.document(eventId).delete()
        FFirestoreReference.eventOrganizer(eventId).document(userId).delete()
    }
}
