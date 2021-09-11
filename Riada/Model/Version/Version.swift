//
//  Version.swift
//  Riada
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

struct Version: Identifiable, Codable {
    @DocumentID var id: String?
    var force_maj: Bool
    var in_review: Bool
    var latest: String
}
