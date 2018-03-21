//
//  ProfilePicture.swift
//  Prism
//
//  Created by Shiv Shah on 3/5/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

public class ProfilePicture {

    public var profilePicUriString: String
    public var isDefault = true

    
    public init(profilePicUriString : String) {
        self.profilePicUriString = profilePicUriString
        self.isDefault =  (self.profilePicUriString.count == 1 && Int(self.profilePicUriString) != nil) ? true : false
    }
    
    public func getHiResDefaultProfilePic() -> UIImage? {
        if isDefault {
            return DefaultProfilePicture.getProfilePicture(index: Int(self.profilePicUriString)!).hiResPicture
        }
        return nil
    }
    
    public func getLowResDefaultProfilePic() -> UIImage? {
        if isDefault {
            return DefaultProfilePicture.getProfilePicture(index: Int(self.profilePicUriString)!).lowResPicture
        }
        return nil
    }
}

