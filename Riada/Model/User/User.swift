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
    
    var toParticipantData: [String: Any]? {
        guard let userId = self.id, let nickName = self.nickName else { return nil }
        var data = [
           "userId": userId,
           "userNickName": nickName,
           "status": ParticipationStatus.pending.rawValue
        ]
        if let avatar = self.avatar {
            data["userAvatar"] = avatar
        }
        return data
    }
    
    var toOrganizerData: [String: Any]? {
        guard let userId = self.id, let nickName = self.nickName else { return nil }
        var data = [
           "userId": userId,
           "userNickName": nickName
        ]
        if let avatar = self.avatar {
            data["userAvatar"] = avatar
        }
        return data
    }
    
    var toParticipantAsOrganizerData: [String: Any]? {
        guard let userId = self.id, let nickName = self.nickName else { return nil }
        var data = [
           "userId": userId,
           "userNickName": nickName,
           "status": ParticipationStatus.accepted.rawValue
        ]
        if let avatar = self.avatar {
            data["userAvatar"] = avatar
        }
        return data
    }
    
    var toAddGuestData: [String: Any]? {
        guard let userId = self.id, let nickName = self.nickName else { return nil }
        var data = [
           "associatedUserId": userId,
           "associatedUserNickName": nickName,
           "status": ParticipationStatus.pending.rawValue
        ]
        if let avatar = self.avatar {
            data["associatedUserAvatar"] = avatar
        }
        return data
    }
}
