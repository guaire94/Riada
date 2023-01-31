//
//  Sport.swift
//  Riada
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

struct Sport: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var emoticon: String
    var image: String
    var rank: Int
    var covers: [String]
    
    var localizedName: String {
        NSLocalizedString(name, comment: "")
    }
}
