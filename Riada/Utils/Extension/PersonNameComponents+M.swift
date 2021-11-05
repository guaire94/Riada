//
//  PersonNameComponents+M.swift
//  Riada
//
//  Created by Guaire94 on 24/10/2021.
//

import Foundation

extension PersonNameComponents {
    
    var username: String {
        var username = givenName ?? ""
        if let familyName = self.familyName  {
            username += " " + familyName
        }
        return username
    }
}
