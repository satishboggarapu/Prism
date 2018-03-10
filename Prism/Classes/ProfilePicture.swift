//
//  ProfilePicture.swift
//  Prism
//
//  Created by Shiv Shah on 3/5/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation


public class ProfilePicture {

    public var profilePicUriString: String
//    public var hiResUri: Uri
//    public var lowResUri: Uri
    public var isDefault = true

    
    public init(profilePicUriString : String) {
        self.profilePicUriString = profilePicUriString
    }
//public ProfilePicture(String profilePicUriString) {
//    this.profilePicUriString = profilePicUriString;
//    isDefault = Character.isDigit(profilePicUriString.charAt(0));
//    hiResUri = getHiResProfilePicUri();
//    lowResUri = getLowResProfilePicUri();
//}
//
//private Uri getHiResProfilePicUri() {
//    if (isDefault) {
//        int profileIndex = Integer.parseInt(profilePicUriString);
//        DefaultProfilePicture picture = DefaultProfilePicture.values()[profileIndex];
//        return Uri.parse(picture.getProfilePicture());
//    }
//    return Uri.parse(profilePicUriString);
//}
//
//private Uri getLowResProfilePicUri() {
//    if (isDefault) {
//        int profileIndex = Integer.parseInt(profilePicUriString);
//        DefaultProfilePicture picture = DefaultProfilePicture.values()[profileIndex];
//        return Uri.parse(picture.getProfilePictureLow());
//    }
//    return Uri.parse(profilePicUriString);
//}


}

