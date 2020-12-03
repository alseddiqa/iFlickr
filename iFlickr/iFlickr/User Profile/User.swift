//
//  User.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import Foundation

class User {
    
    var name: String
    var email: String
    var userId: String
    var isFollowed: Bool?
    
    init(id: String , theName: String, theEmail: String) {
        name = theName
        userId = id
        email = theEmail
    }
    
}
