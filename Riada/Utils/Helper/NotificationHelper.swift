//
//  NotificationManager.swift
//  Mooddy
//
//  Created by Quentin Gallois on 07/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()
    
    var currentNotification: CurrentNotification?
    
    public func clearCurrentNotification() {
        currentNotification = nil
    }
        
    public func setCurrentNotification(info: [String: Any]) {
        guard let userId = info["userId"] as? String,
              let title = info["title"] as? String,
              let message = info["message"] as? String,
              let rawType = info["type"] as? String,
              let type = MNotificationType(rawValue: rawType),
              let elementId = info["elementId"] as? String else {
            return
        }
        self.currentNotification = CurrentNotification(userId: userId,
                                                       title: title,
                                                       message: message,
                                                       type: type,
                                                       elementId: elementId)
    }
}
