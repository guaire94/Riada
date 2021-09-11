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
    var tile: String
    var description: String
    var nbPlayer: String
    var date: Timestamp
    var placeId: String
    var placeAddress: String
    var placeLng: Double
    var placeLat: Double
    var sportId: String
    var sportName: String
    var createdDate: Timestamp
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: placeLng, longitude: placeLng)
    }
}
