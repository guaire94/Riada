//
//  Team.swift
//  Riada
//
//  Created by Guaire94 on 22/01/2023.
//

import Firebase
import FirebaseFirestoreSwift

struct TeamMember {
    var userId: String
    var userNickName: String
    var userAvatar: String?
    var isGuest: Bool
}
