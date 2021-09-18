//
//  ManagerUserPreferences.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import Foundation

class ManagerUserPreferences {
    
    // MARK: - Constants
    private enum Constants {
        enum Keys {
            static let cityName = "cityNameKey"
            static let cityLat = "cityLatKey"
            static let cityLng = "cityLngKey"
        }
    }
    
    // MARK: - Properties
    private var userDefaults: UserDefaults
    var cityName: String?
    var cityLat: Double?
    var cityLng: Double?
    
    var city: City? {
        guard let cityName = cityName, let cityLat = cityLat, let cityLng = cityLng else { return nil }
        return City(name: cityName, lat: cityLat, lng: cityLng)
    }
    
    // MARK: - Singleton
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    static let shared = ManagerUserPreferences()
    
    // MARK: - Public
    func clear() {
        userDefaults.setValue(nil, forKey: Constants.Keys.cityName)
        userDefaults.setValue(nil, forKey: Constants.Keys.cityLat)
        userDefaults.setValue(nil, forKey: Constants.Keys.cityLng)
        cityName = nil
        cityLat = nil
        cityLng = nil
    }
    
    func load() {
        cityName = userDefaults.value(forKeyPath: Constants.Keys.cityName) as? String
        cityLat = userDefaults.value(forKeyPath: Constants.Keys.cityLat) as? Double
        cityLng = userDefaults.value(forKeyPath: Constants.Keys.cityLng) as? Double
    }
    
    func save(city: City) {
        self.cityName = city.name
        self.cityLat = city.lat
        self.cityLng = city.lng

        userDefaults.set(cityName, forKey: Constants.Keys.cityName)
        userDefaults.set(cityLat, forKey: Constants.Keys.cityLat)
        userDefaults.set(cityLng, forKey: Constants.Keys.cityLng)
    }
}
