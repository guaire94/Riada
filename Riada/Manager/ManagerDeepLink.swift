//
//  ManagerDeepLink.swift
//  Riada
//
//  Created by Guaire94 on 26/09/2021.
//

import Foundation

enum DeepLinkType {
    case eventDetails(eventId: String)
}

class ManagerDeepLink {
    
    // MARK: - Constants
    private enum Constants {
        enum id {
            static let event = "eventId"
        }
        
        enum host {
            static let eventDetails = "/eventDetails"
        }
        
        enum notification {
            static let deeplink = "deeplink"
        }
    }
    
    // MARK: - Singleton
    static let shared = ManagerDeepLink()
    private init() {}
    
    // MARK: - Properties
    private(set) var currentDeepLink: DeepLinkType?
    
    // MARK: - Public
    func clear() {
        currentDeepLink = nil
    }
    
    func setDeeplinkFromDeepLink(url: URL) {
        parseDeeplink(url: url)
    }
    
    func setDeeplinkFromNotification(info: [String: Any]) {
        guard let deepLink = info[Constants.notification.deeplink] as? String,
           let url = URL(string: deepLink) else {
            return
        }
        
        parseDeeplink(url: url)
    }
    
    // MARK: - Private
    private func parseDeeplink(url: URL) {        
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        
        currentDeepLink = nil
        switch url.path {
        case Constants.host.eventDetails:
            guard let eventId = parameters[Constants.id.event] else { return }
            currentDeepLink = .eventDetails(eventId: eventId)
        default:
            currentDeepLink = nil
        }
    }
    
    func createDeeplinkFrom(eventId: String) -> String {
        Constants.host.eventDetails + "?" + Constants.id.event + "=" + eventId
    }
}
