//
//  Owner.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct Organizer: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var userNickName: String
    var userAvatar: String?
}
