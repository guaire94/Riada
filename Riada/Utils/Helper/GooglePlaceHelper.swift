//
//  GooglePlaceHelper.swift
//  Mooddy
//
//  Created by Quentin Gallois on 07/09/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import CoreLocation

public typealias ArrayBlock<T> = ((Array<T>,Error?)->Void)

enum GoogleAutocompleteTypes:String {
    case urlScheme = "https"
    case urlDomain = "maps.googleapis.com"
    case urlEndpoint = "/maps/api/place/autocomplete/json"
}

let kGoogleAutocompleteAPIKey = "AIzaSyCxwGtt2_ejkbSEtal7zFk44PS3JzmRsYc"

class GooglePlace: NSObject {
    var name:String
    var detail:String
    private var address:String
    var addressWithDetail: String {
        get {
            return name + ", " + detail
        }
    }
    
    init(info:[String:Any]) {
        let structured = (info["structured_formatting"] as? NSObject)
        
        name = structured?["main_text"] as? String ?? ""
        detail = structured?["secondary_text"] as? String ?? ""
        address = info["description"] as? String ?? ""
    }
    
    func getLocation(block:@escaping (CLLocationCoordinate2D) -> Void?) {
        CLGeocoder().geocodeAddressString(address) { (placeList, error) in
            if let coordinate = placeList?.first?.location?.coordinate {
                block(coordinate)
            }
        }
    }
}

class GooglePlaceHelper: NSObject {
    
    static let shared = GooglePlaceHelper()
    var activeTask:URLSessionDataTask?
    
    func getUrlRequest(string:String, type:String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = GoogleAutocompleteTypes.urlScheme.rawValue
        urlComponents.host = GoogleAutocompleteTypes.urlDomain.rawValue
        urlComponents.path = GoogleAutocompleteTypes.urlEndpoint.rawValue
        
        let params = ["input" : string, "key" : kGoogleAutocompleteAPIKey, "radius" : "50000", "types": type]
        let items = params.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = items
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func getPlaces(searchString:String, type:String = "address", block:@escaping ArrayBlock<GooglePlace>) {
        if searchString.count == 0 {
            block([],nil)
            return
        }
        guard let request = getUrlRequest(string: searchString, type:type ) else {
            block([],nil)
            return
        }
        if let task = activeTask {
            task.cancel()
        }
        activeTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.activeTask = nil
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSObject
            let list = json?["predictions"] as? [[String:Any]]
            let places =  list?.map { GooglePlace(info: $0) }
            DispatchQueue.main.async {
                block(places ?? [], error)
            }
        }
        activeTask?.resume()
    }
}

extension NSObject {
    subscript(key:String) -> NSObject? {
        get {
            return self.value(forKey: key) as? NSObject
        }
    }
}


