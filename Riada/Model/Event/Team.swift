//
//  Team.swift
//  Riada
//
//  Created by Guaire94 on 22/01/2023.
//

import Firebase
import FirebaseFirestoreSwift

struct Team: Identifiable, Codable {
    @DocumentID var id: String?
    var teamId: String
    var teamName: String
}
