//
//  NotificationService.swift
//  Riada
//
//  Created by Quentin Gallois on 07/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import Firebase
import FirebaseMessaging
import FirebaseFirestore

class ServiceDeviceToken {
    static let shared = ServiceDeviceToken()
    
    func register() {
        guard let userId = ManagerUser.shared.user?.id, let token = Messaging.messaging().fcmToken else { return }
        FFirestoreReference.users.document(userId).updateData(["devices": FieldValue.arrayUnion([token])])
    }
    
    func unregister(token: String) {
        guard let userId = ManagerUser.shared.user?.id else { return }
        FFirestoreReference.users.document(userId).updateData(["devices": FieldValue.arrayRemove([token])])
    }
}
