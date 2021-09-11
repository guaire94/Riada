//
//  User.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var mail: String?
    var nickName: String?
    var avatar: String?
    var createdDate: Timestamp
}
