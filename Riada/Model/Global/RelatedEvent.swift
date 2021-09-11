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
    var tile: String
    var nbPlayer: String
    var date: Timestamp
    var placeAddress: String
    var placeLng: Double
    var placeLat: Double
}
