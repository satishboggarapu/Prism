//
//  Member.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class MyUser: CustomStringConvertible {
//    var uid: String!
    var userName: String!
    var fullName: String!
    var email: String!
    var password: String!
    var profilePic: String!
    
    init(userName: String, fullName: String, email: String, password: String, profilePic: String) {
//        self.uid = uid
        self.userName = userName
        self.fullName = fullName
        self.email = email
        self.password = password
        self.profilePic = profilePic
    }
    
    public var description: String {
        var description = "Member("
//        description += "uid: \(self.uid!),"
        description += "userName: \(self.userName!),"
        description += "fullName: \(self.fullName!),"
        description += "email: \(self.email!),"
        description += "password: \(self.password!),"
        description += "profilePic: \(self.profilePic!))"
        return description
    }
    
}

