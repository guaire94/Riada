//
//  RelatedEvent.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct RelatedEvent: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var nbPlayer: Int
    var date: Timestamp
    var sportName: String
    var placeAddress: String
    var placeCoordinate: GeoPoint
    
    var sportLocalizedName: String {
        NSLocalizedString(sportName, comment: "")
    }
}
