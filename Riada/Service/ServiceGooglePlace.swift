//
//  ServiceGooglePlace.swift
//  Mooddy
//
//  Created by Quentin Gallois on 07/09/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import CoreLocation

public typealias ArrayBlock<T> = ((Array<T>,Error?)->Void)
public typealias Block<T> = ((T)->Void)

class GooglePlace: NSObject {
    var name: String
    var id: String

    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    init?(info: [String:Any]) {
        guard let description = info["description"] as? String,
              let placeId = info["place_id"] as? String else { return nil }
        self.name = description
        self.id = placeId
    }
}

class ServiceGooglePlace: NSObject {
    
    private enum Constants {
        static let urlScheme = "https"
        static let urlDomain = "maps.googleapis.com"
        static let autocompleteEndpoint = "/maps/api/place/autocomplete/json"
        static let placeDetailsEndpoint = "/maps/api/place/details/json"
        static let photoEndpoint = "/maps/api/place/photo"
    }
    
    static let shared = ServiceGooglePlace()
    var activeTask:URLSessionDataTask?
    
    func getPlaces(searchString: String, block: @escaping ArrayBlock<GooglePlace>) {
        if searchString.count == 0 {
            block([], nil)
            return
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlDomain
        urlComponents.path = Constants.autocompleteEndpoint
        
        let params = ["input" : searchString, "key" : Config.googleAPIKey, "type" : "(cities)"]
        let items = params.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = items
        guard let url = urlComponents.url else { return block([], nil) }
        let request = URLRequest(url: url)
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
            let places = list?.compactMap { GooglePlace(info: $0) }
            DispatchQueue.main.async {
                block(places ?? [], error)
            }
        }
        activeTask?.resume()
    }
    
    func getPlaceDetails(placeId: String, block: @escaping Block<(CLLocation)?>) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlDomain
        urlComponents.path = Constants.placeDetailsEndpoint

        let params = ["place_id" : placeId, "key" : Config.googleAPIKey, "fields" : "name,geometry"]
        let items = params.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = items
        guard let url = urlComponents.url else { return block(nil) }
        let request = URLRequest(url: url)
        if let task = activeTask {
            task.cancel()
        }
        activeTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.activeTask = nil
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSObject,
                  let result = json["result"] as? [String: Any],
                  let geometry = result["geometry"] as? [String: Any],
                  let location = geometry["location"] as? [String: Any],
                  let lat = location["lat"] as? Double,
                  let lng = location["lng"] as? Double else {
                return block(nil)
            }
            DispatchQueue.main.async {
                block(CLLocation(latitude: lat, longitude: lng))
            }
        }
        activeTask?.resume()
    }
    
    func getPlacePhotos(placeId: String, block: @escaping Block<([URL])>) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlDomain
        urlComponents.path = Constants.placeDetailsEndpoint

        let params = ["place_id" : placeId, "key" : Config.googleAPIKey, "fields" : "photos"]
        let items = params.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = items
        guard let url = urlComponents.url else { return block([]) }
        let request = URLRequest(url: url)
        if let task = activeTask {
            task.cancel()
        }
        activeTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.activeTask = nil
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSObject,
                  let result = json["result"] as? [String: Any],
                  let photos = result["photos"] as? [[String: Any]] else {
                return block([])
            }
            
            var photosUrl: [URL] = []
            for photo in photos {
                if let ref = photo["photo_reference"] as? String {
                    if let url = self.buildPhotoUrl(photoRef: ref) {
                        photosUrl.append(url)
                    }
                }
            }
            DispatchQueue.main.async {
                block(photosUrl)
            }
        }
        activeTask?.resume()
    }
    
    private func buildPhotoUrl(photoRef: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlDomain
        urlComponents.path = Constants.photoEndpoint

        let params = ["maxwidth": "200", "key": Config.googleAPIKey, "photo_reference": photoRef]
        let items = params.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = items
        return urlComponents.url
    }
}

extension NSObject {
    subscript(key:String) -> NSObject? {
        get {
            value(forKey: key) as? NSObject
        }
    }
}


