//
//  Guest.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct Guest: Identifiable, Codable {
    @DocumentID var id: String?
    var associatedUserId: String
    var associatedNickName: String
    var associatedAvatar: String?
    var guestNickName: String
    var status: String
    
    var participationStatus: ParticipationStatus {
        ParticipationStatus(rawValue: status) ?? .pending
    }
}
