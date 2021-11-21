//
//  Event.swift
//  Riada
//
//  Created by Quentin Gallois on 28/10/2020.
//

import Firebase
import FirebaseFirestoreSwift
import MapKit
import EventKitUI

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var nbPlayer: Int
    var nbAcceptedPlayer: Int
    var date: Timestamp
    var placeId: String
    var placeName: String
    var placeAddress: String
    var placeCoordinate: GeoPoint
    var sportId: String
    var sportEmoticon: String
    var sportName: String
    var createdDate: Timestamp
    var isPrivate: Bool

    var location: CLLocation {
        CLLocation(latitude: placeCoordinate.latitude, longitude: placeCoordinate.longitude)
    }
    
    var sportLocalizedName: String {
        NSLocalizedString(sportName, comment: "")
    }
    
    func toCalendarEvent(deeplink: URL, with eventStore: EKEventStore) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .hour, value: 3, to: date.dateValue())
        
        event.title = "\(sportName) - \(title)"
        event.startDate = date.dateValue()
        event.endDate = endDate
        event.isAllDay = false
        
        let structuredLocation = EKStructuredLocation(title: placeName)
        structuredLocation.geoLocation = location
        event.structuredLocation = structuredLocation

        event.url = deeplink        
        return event
    }
    
    var toRelatedData: [String: Any]? {
        guard let eventId = self.id else { return nil }
        let data: [String: Any] = [
           "eventId": eventId,
           "title": title,
           "nbPlayer": nbPlayer,
           "date": date,
           "sportName": sportName,
           "placeAddress": placeAddress,
           "placeCoordinate": placeCoordinate,
        ]
        return data
    }
    
    var toCreateData: [String: Any]? {
        guard let _ = self.id else { return nil }
        let data: [String: Any] = [
           "title": title,
           "description": description,
           "nbPlayer": nbPlayer,
           "nbAcceptedPlayer": nbAcceptedPlayer,
           "date": date,
           "placeId": placeId,
           "placeName": placeName,
           "placeAddress": placeAddress,
           "placeCoordinate": placeCoordinate,
           "sportId": sportId,
           "sportEmoticon": sportEmoticon,
           "sportName": sportName,
           "createdDate": createdDate,
           "isPrivate": isPrivate,
        ]
        return data
    }
    
    var toUpdateData: [String: Any]? {
        guard let _ = self.id else { return nil }
        let data: [String: Any] = [
           "title": title,
           "description": description,
           "nbPlayer": nbPlayer,
           "date": date,
           "placeId": placeId,
           "placeName": placeName,
           "placeAddress": placeAddress,
           "placeCoordinate": placeCoordinate,
           "sportId": sportId,
           "sportEmoticon": sportEmoticon,
           "sportName": sportName,
           "createdDate": createdDate,
           "isPrivate": isPrivate,
        ]
        return data
    }
}
