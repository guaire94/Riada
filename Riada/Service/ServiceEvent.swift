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

class ServiceEvent {
    
    enum Constant {
        static var maxMilesDistance: Double = 20
        static var OneMileLat: Double = 0.0144927536231884
        static var OneMileLng: Double = 0.0181818181818182
    }
    
    static func getNextEvents(completion: @escaping ([Event]) -> Void) {
        let lat = ManagerUser.shared.currentCity.lat
        let lng = ManagerUser.shared.currentCity.lng
        
        let lowerLat = lat - (Constant.OneMileLat * Constant.maxMilesDistance)
        let lowerLon = lng - (Constant.OneMileLng * Constant.maxMilesDistance)
        
        let greaterLat = lat + (Constant.OneMileLat * Constant.maxMilesDistance)
        let greaterLon = lng + (Constant.OneMileLng * Constant.maxMilesDistance)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        
        FFirestoreReference.events.order(by: "placeCoordinate").whereField("placeCoordinate", isGreaterThan: lesserGeopoint).whereField("placeCoordinate", isLessThan: greaterGeopoint).start(after: [Timestamp()]).getDocuments() { (querySnapshot, err) in
            var events: [Event] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(events)
                return
            }
            for document in documents {
                if let event = try? document.data(as: Event.self) {
                    events.append(event)
                }
            }
            completion(events)
        }
    }
    
    static func getEventOwner(eventId: String, completion: @escaping (Organizer?) -> Void) {
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
    
    static func getEventParticipants(eventId: String, completion: @escaping ([Participant]) -> Void) {
        FFirestoreReference.eventParticipants(eventId).getDocuments() { (querySnapshot, err) in
            var participants: [Participant] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(participants)
                return
            }
            for document in documents {
                if let participant = try? document.data(as: Participant.self) {
                    participants.append(participant)
                }
            }
            completion(participants)
        }
    }
    
    static func getNbEventGuests(eventId: String, completion: @escaping ([Guest]) -> Void) {
        FFirestoreReference.eventParticipants(eventId).getDocuments() { (querySnapshot, err) in
            var guests: [Guest] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(guests)
                return
            }
            for document in documents {
                if let guest = try? document.data(as: Guest.self) {
                    guests.append(guest)
                }
            }
            completion(guests)
        }
    }
}
