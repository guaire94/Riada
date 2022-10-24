//
//  ManagerAuth.swift
//  Riada
//
//  Created by Quentin Gallois on 27/10/2020.
//

import FirebaseAuth
import MapKit
import SDWebImage
import FirebaseMessaging

class ManagerUser {
    
    static let shared = ManagerUser()
    
    private lazy var dispatchGroup = DispatchGroup()
    
    var user: User?
    var favoriteSportIds: [String] = []
    var currentCity: City = PlaceHolderCity.dubai.city {
        didSet {
            updateLocation(city: currentCity)
        }
    }
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var isConnected: Bool {
        user != nil
    }

    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        
        ManagerUserPreferences.shared.load()
        if let city = ManagerUserPreferences.shared.city {
            currentCity = city
        } else {
            currentCity = PlaceHolderCity.dubai.city
        }
        
        ServiceUser.getProfile() { (user) in
            self.user = user
            self.favoriteSportIds = user?.favoritesSports ?? []
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}

// MARK: User informations
extension ManagerUser {
    
    func updateNickName(nickName: String) {
        user?.nickName = nickName
        ServiceUser.updateNickName(nickName: nickName)
    }
    
    func updateAvatar(avatarUrl: String) {
        user?.avatar = avatarUrl
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)

        ServiceUser.updateAvatar(avatarUrl: avatarUrl)
    }

    func updateLocation(city: City) {
        ManagerUserPreferences.shared.save(city: city)
        user?.location = city.geoPoint
        ServiceUser.updateLocation(city: city)
    }
}


// MARK: Favorite Sport
extension ManagerUser {
    
    func isFavoriteSport(sport: Sport) -> Bool {
        guard let sportId = sport.id else { return false }
        return favoriteSportIds.contains(where: {$0 == sportId})
    }
    
    func addFavoriteSport(sport: Sport) {
        guard let sportId = sport.id else { return }
        favoriteSportIds.append(sportId)
        ServiceUser.updateFavoriteSports(favoriteSportIds: favoriteSportIds)
    }
    
    func removeFavoriteSport(sport: Sport) {
        guard let sportId = sport.id,
                let index = favoriteSportIds.firstIndex(where: { $0 == sportId }) else {
                    return
        }
        favoriteSportIds.remove(at: index)
        ServiceUser.updateFavoriteSports(favoriteSportIds: favoriteSportIds)
    }
    
    func signOut(completion: @escaping () -> Void) {
        Messaging.messaging().token { [weak self] token, error in
            if let token = token, error == nil {
                ServiceDeviceToken.shared.unregister(token: token)
            }
            (UIApplication.shared.delegate as? AppDelegate)?.unregisterForRemoteNotifications()
            try? Auth.auth().signOut()
            self?.user = nil
            self?.favoriteSportIds = []
            self?.currentCity = PlaceHolderCity.dubai.city
            completion()
        }
    }
}
