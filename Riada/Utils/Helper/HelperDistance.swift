//
//  HelperDistance.swift
//  Riada
//
//  Created by Guaire94 on 19/11/2021.
//

import FirebaseFirestore

class HelperDistance {
    
    // MARK: - Constants
    enum Constant {
        static var maxMilesDistance: Double = 20
        static var OneMileLat: Double = 0.0144927536231884
        static var OneMileLng: Double = 0.0181818181818182
    }

    // MARK: - Properties
    static let shared = HelperDistance()
    
    // MARK: - Publics
    func computeLesserGeoPoint(lat: Double, lng: Double) -> GeoPoint {
        let lowerLat = lat - (Constant.OneMileLat * Constant.maxMilesDistance)
        let lowerLon = lng - (Constant.OneMileLng * Constant.maxMilesDistance)

        return GeoPoint(latitude: lowerLat, longitude: lowerLon)
    }
    
    func computeGreatestGeoPoint(lat: Double, lng: Double) -> GeoPoint {
        let greaterLat = lat + (Constant.OneMileLat * Constant.maxMilesDistance)
        let greaterLon = lng + (Constant.OneMileLng * Constant.maxMilesDistance)

        return GeoPoint(latitude: greaterLat, longitude: greaterLon)
    }
}
