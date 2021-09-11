//
//  ServiceSport.swift
//  Riada
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import CodableFirebase

class ServiceSport {
    
    static func getSports(completion: @escaping ([Sport]) -> Void) {
        FFirestoreReference.sports.order(by: "rank").getDocuments() { (querySnapshot, err) in
            var sports: [Sport] = []
            guard err == nil, let documents = querySnapshot?.documents else {
                completion(sports)
                return
            }
            for document in documents {
                if let sport = try? FirebaseDecoder().decode(Sport.self, from: document.data()) {
                    sports.append(sport)
                }
            }
            completion(sports)
        }
    }
}
