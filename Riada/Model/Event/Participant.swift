//
//  Participant.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct Participant: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var userNickName: String
    var userAvatar: String?
    var teamId: String?
    var status: String
    
    var participationStatus: ParticipationStatus {
        ParticipationStatus(rawValue: status) ?? .pending
    }    
}
