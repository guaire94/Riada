//
//  ManagerAuth.swift
//  Riada
//
//  Created by Quentin Gallois on 27/10/2020.
//

import FirebaseAuth
import MapKit

class ManagerUser {
    
    static let shared = ManagerUser()
    
    private lazy var dispatchGroup = DispatchGroup()
    
    var user: User?
    var favoriteSports: [FavoriteSport] = []
    var currentCity: City = PlaceHolderCity.dubai.city
    
    var isConnected: Bool {
        Auth.auth().currentUser != nil
    }

    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        ManagerUserPreferences.shared.load()
        if let city = ManagerUserPreferences.shared.city {
            currentCity = city
        }
        
        ServiceUser.getProfile() { (user) in
            self.user = user
            self.dispatchGroup.leave()
        }
        ServiceUser.getFavoriteSports() { (sports) in
            self.favoriteSports = sports
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func clear() {
        try? Auth.auth().signOut()
        user = nil
        favoriteSports = []
        currentCity = PlaceHolderCity.dubai.city
    }
}

// MARK: Favorite Sport
extension ManagerUser {
    
    func isFavoriteSport(sport: Sport) -> Bool {
        favoriteSports.contains(where: {$0.id == sport.id})
    }
    
    func addFavoriteSport(sport: Sport) {
        let favoriteSport = FavoriteSport(from: sport)
        favoriteSports.append(favoriteSport)
        ServiceUser.addFavoriteSports(favoriteSport: favoriteSport)
    }
    
    func removeFavoriteSport(sport: Sport) {
        let favoriteSport = FavoriteSport(from: sport)
        guard let index = favoriteSports.firstIndex(where: { $0.id == sport.id }) else { return }
        favoriteSports.remove(at: index)
        ServiceUser.removeFavoriteSports(favoriteSport: favoriteSport)
    }
}
