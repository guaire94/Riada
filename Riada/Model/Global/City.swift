//
//  MCity.swift
//  Riada
//
//  Created by Quentin Gallois on 29/10/2020.
//

import MapKit
import FirebaseFirestore

struct City {
    var name: String
    var lat: Double
    var lng: Double

    var location: CLLocationCoordinate2D {
        CLLocation(latitude: lat, longitude: lng).coordinate
    }
    
    var geoPoint: GeoPoint {
        GeoPoint(latitude: lat, longitude: lng)
    }
}

enum PlaceHolderCity: CaseIterable {
    case paris
//    case dubai
//    case abuDhabi
//    case sharjah

    var name: String {
        switch self {
        case .paris:
            return "Paris"
//        case .dubai:
//            return "Dubai"
//        case .abuDhabi:
//            return "Abu Dhabi"
//        case .sharjah:
//            return "Sharjah"
        }
    }
    
    var placeId: String {
        switch self {
        case .paris:
            return "ChIJD7fiBh9u5kcRYJSMaMOCCwQ"
//        case .dubai:
//            return "ChIJRcbZaklDXz4RYlEphFBu5r0"
//        case .abuDhabi:
//            return "ChIJufI-cg9EXj4RCBGXQZMuzMc"
//        case .sharjah:
//            return "ChIJS5bn7V9fXz4RiW0fnKEKgyo"
        }
    }
    
    var lat: Double {
        switch self {
        case .paris:
            return 48.856614
//        case .dubai:
//            return 25.276987
//        case .abuDhabi:
//            return 24.466667
//        case .sharjah:
//            return 25.348766
        }
    }
    
    var lng: Double {
        switch self {
        case .paris:
            return 2.3522219
//        case .dubai:
//            return 55.296249
//        case .abuDhabi:
//            return 54.366669
//        case .sharjah:
//            return 55.405403
        }
    }
    
    var city: City {
        City(name: name, lat: lat, lng: lng)
    }
}
