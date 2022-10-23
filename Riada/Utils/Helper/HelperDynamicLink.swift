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
        static var domain = "https://socialsport.page.link"
        static var scheme = "https"
        static var host = "social-sport-c41f3.firebaseapp.com"
        static var eventDetailsPath = "/eventDetails"
    }
        
    static func generateEventDetails(event: Event, completion: @escaping (URL?) -> Void) {
        guard let eventId = event.id else { return }
        
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.eventDetailsPath
        
        let itemIDQueryItem = URLQueryItem(name: "eventId", value: eventId)
        components.queryItems = [itemIDQueryItem]
                
        guard let link = components.url,
              let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: Constants.domain) else {
                  return
              }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
          linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: Config.androidPackageName)
        linkBuilder.iOSParameters?.appStoreID = Config.AppStoreId
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "\(event.sportLocalizedName) - \(event.title)"
        linkBuilder.socialMetaTagParameters?.descriptionText = event.description
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: "https://social-sport-c41f3.firebaseapp.com/logo.png")!

        linkBuilder.shorten { url, warnings, error in
            if let warnings = warnings {
                for warning in warnings {
                    print("Warning: \(warning)")
                }
            }
            guard let url = url else { return }
            completion(url)
        }
    }
}
