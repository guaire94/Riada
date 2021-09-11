//
//  ServiceNotification.swift
//  Riada
//
//  Created by P995987 on 12/12/2020.
//

import Firebase
import FirebaseMessaging
import FirebaseFirestore

class ServiceNotification {
    
    static let shared = ServiceNotification()
    lazy var functions = Functions.functions()
    
//    func eventAcceptParticipation(_ event: Event,_ participant: EventParticipant) {
//        let type: MNotificationType = .eventAcceptParticipation
//        let title = String(format: type.title, arguments: [event.type?.rawValue.uppercased() ?? "", event.title])
//
//        let data = ["env": firebaseEnv,
//                    "coachId": participant.coachId,
//                    "title": title,
//                    "message": type.message,
//                    "type": type.rawValue,
//                    "elementId": event.id]
//        functions.httpsCallable(FFunctions.sendNotification).call(data) { (_, _) in }
//    }
//
//    func eventRefuseParticipation(_ event: Event,_ participant: EventParticipant) {
//        let type: MNotificationType = .eventRefuseParticipation
//        let title = String(format: type.title, arguments: [event.type?.rawValue.uppercased() ?? "", event.title])
//
//        let data = ["env": firebaseEnv,
//                    "coachId": participant.coachId,
//                    "title": title,
//                    "message": type.message,
//                    "type": type.rawValue,
//                    "elementId": event.id]
//        functions.httpsCallable(FFunctions.sendNotification).call(data) { (_, _) in }
//    }
//
//    func eventParticipation(_ event: Event,_ owner: EventOwner) {
//        guard let coach = ManagerAuth.shared.coach else { return }
//        let type: MNotificationType = .eventParticipation
//        let title = String(format: type.title, arguments: [event.type?.rawValue.uppercased() ?? "", event.title])
//        let message = String(format: type.message, arguments: [coach.fullname])
//
//        let data = ["env": firebaseEnv,
//                    "coachId": owner.coachId,
//                    "title": title,
//                    "message": message,
//                    "type": type.rawValue,
//                    "elementId": event.id]
//        functions.httpsCallable(FFunctions.sendNotification).call(data) { (_, _) in }
//    }
//
//    func eventModification(_ event: Event,_ participants: [EventParticipant]) {
//        let type: MNotificationType = .eventModification
//        let title = String(format: type.title, arguments: [event.type?.rawValue.uppercased() ?? "", event.title])
//
//        for participant in participants {
//            let data = ["env": firebaseEnv,
//                        "coachId": participant.coachId,
//                        "title": title,
//                        "message": type.message,
//                        "type": type.rawValue,
//                        "elementId": event.id]
//            functions.httpsCallable(FFunctions.sendNotification).call(data) { (_, _) in }
//        }
//    }
//
//    func eventCancelation(_ event: Event,_ participants: [EventParticipant]) {
//        let type: MNotificationType = .eventCancelation
//        let title = String(format: type.title, arguments: [event.type?.rawValue.uppercased() ?? "", event.title])
//
//        for participant in participants {
//            let data = ["env": firebaseEnv,
//                        "coachId": participant.coachId,
//                        "title": title,
//                        "message": type.message,
//                        "type": type.rawValue,
//                        "elementId": event.id]
//            functions.httpsCallable(FFunctions.sendNotification).call(data) { (_, _) in }
//        }
//    }
}
