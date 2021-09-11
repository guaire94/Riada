//
//  FavoriteSport.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct FavoriteSport: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    
    init(from sport: Sport) {
        self.id = sport.id
        self.name = sport.name
    }
    
    var toData: [String : Any] {
        [
           "id": self.id ?? "",
           "name": self.name
        ]
    }
}
