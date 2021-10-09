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
    var sportName: String
    var createdDate: Timestamp
    
    var location: CLLocation {
        CLLocation(latitude: placeCoordinate.latitude, longitude: placeCoordinate.longitude)
    }
    
    var sportLocalizedName: String {
        NSLocalizedString(sportName, comment: "")
    }
    
    func toCalendarEvent(with eventStore: EKEventStore) -> EKEvent {
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

        // TODO: add deeplink
//        if let urlString = self.event.webLink,
//           let url = URL(string: urlString) {
//            event.url = url
//        }
        
        return event
    }
}
