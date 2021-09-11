//
//  MCity.swift
//  Riada
//
//  Created by Quentin Gallois on 29/10/2020.
//

import MapKit

struct City {
    var name: String
    var lat: Double
    var lng: Double

    private var location: CLLocationCoordinate2D {
         CLLocation(latitude: lat, longitude: lng).coordinate
    }
}

enum PlaceHolderCity: CaseIterable {
    case dubai
    case abuDhabi
    case sharjah

    var name: String {
        switch self {
        case .dubai:
            return "Dubai"
        case .abuDhabi:
            return "Abu Dhabi"
        case .sharjah:
            return "Sharjah"
        }
    }
    
    var lat: Double {
        switch self {
        case .dubai:
            return 25.276987
        case .abuDhabi:
            return 24.466667
        case .sharjah:
            return 25.348766
        }
    }
    
    var lng: Double {
        switch self {
        case .dubai:
            return 55.296249
        case .abuDhabi:
            return 54.366669
        case .sharjah:
            return 55.405403
        }
    }
    
    var city: City {
        City(name: name, lat: lat, lng: lng)
    }
}
