//
//  Notification.swift
//  Riada
//
//  Created by Guaire94 on 10/09/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct Notification: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var message: String
    var deeplink: String?
    var createdDate: Timestamp
}
