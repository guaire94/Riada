//
//  Event.swift
//  Riada
//
//  Created by Quentin Gallois on 28/10/2020.
//

import Firebase
import FirebaseFirestoreSwift
import MapKit

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
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: placeCoordinate.latitude, longitude: placeCoordinate.longitude)
    }
    
    var sportLocalizedName: String {
        NSLocalizedString(sportName, comment: "")
    }
}
