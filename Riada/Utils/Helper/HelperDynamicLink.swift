//
//  HelperDynamicLink.swift
//  Riada
//
//  Created by Guaire94 on 01/10/2021.
//

import FirebaseDynamicLinks
import Foundation

class HelperDynamicLink {
    
    enum Constants {
        static var domainURIPrefix = "https://riada.page.link"
        static var deeplink = "https://social-sport-c41f3.firebaseapp.com/"
        static var eventDetailsLink = Constants.deeplink + "?eventId="
    }
        
    static func generateEventDetails(eventId: String, completion: @escaping (URL?) -> Void) {
        guard let link = URL(string: Constants.eventDetailsLink + eventId),
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: Constants.domainURIPrefix) else {
            return completion(nil)
        }
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.socialSport.app.SocialSport")
        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.riada")
        
        let options = DynamicLinkComponentsOptions()
        options.pathLength = .short
        linkBuilder.options = options
        
        guard let longDynamicLink = linkBuilder.url else { return completion(nil) }
        print("The long URL is: \(longDynamicLink)")
        completion(longDynamicLink)
    }
}
