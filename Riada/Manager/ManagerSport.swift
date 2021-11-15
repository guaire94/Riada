//
//  ManagerSport.swift
//  Riada
//
//  Created by Guaire94 on 14/10/2021.
//

import Foundation

class ManagerSport {
    
    static let shared = ManagerSport()
        
    private lazy var dispatchGroup = DispatchGroup()

    var selectedSport: Sport?
    var sports: [Sport] = []
    
    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
                
        ServiceSport.getSports() { (sports) in
            self.sports = sports
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
