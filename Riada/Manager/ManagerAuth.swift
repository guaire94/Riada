//
//  ManagerAuth.swift
//  Riada
//
//  Created by Quentin Gallois on 27/10/2020.
//

import FirebaseAuth
import MapKit

class ManagerAuth {
    
    static let shared = ManagerAuth()
    
    private lazy var dispatchGroup = DispatchGroup()
    
    var user: User?
    var favoritesSport: [FavoriteSport] = []
    var currentCity: City = PlaceHolderCity.dubai.city
    
    var isConnected: Bool {
        try? Auth.auth().signOut()
        return Auth.auth().currentUser != nil
    }

    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        ServiceUser.getProfile() { (user) in
            self.user = user
            self.dispatchGroup.leave()
        }
        ServiceUser.getFavoriteSports() { (sports) in
            self.favoritesSport = sports
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func clear() {
        try? Auth.auth().signOut()
        user = nil
        favoritesSport = []
        currentCity = PlaceHolderCity.dubai.city
    }
}
