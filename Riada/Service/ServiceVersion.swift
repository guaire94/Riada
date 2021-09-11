//
//  ServiceVersion.swift
//  Riada
//
//  Created by Quentin Gallois on 22/10/2020.
//

import CodableFirebase
import FirebaseFirestore

class ServiceVersion {
    
    static func check(completion: @escaping (Version?) -> Void) {
        FFirestoreReference.version.getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data(),
                  let version = try? FirebaseDecoder().decode(Version.self, from: data) else {
                completion(nil)
                return
            }
            completion(version)
        }
    }
}


