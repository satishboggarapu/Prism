//
//  Defaults.swift
//  Prism
//
//  Created by Shiv Shah on 3/6/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import Firebase

public class Default {
    
    private static let databaseReference = Database.database().reference()
    public static let ALL_POSTS_REFERENCE = databaseReference.child(Key.DB_REF_ALL_POSTS)
    public static let USERS_REFERENCE = databaseReference.child(Key.DB_REF_USER_PROFILES)
    public static let ACCOUNT_REFERENCE = databaseReference.child(Key.DB_REF_ACCOUNTS)
    public static let NOTIFICATIONS_REFERENCE = databaseReference.child(Key.DB_REF_USER_PROFILES).child(CurrentUser.prismUser.getUid()).child(Key.DB_REF_USER_NOTIFICATIONS)

    
    public static let STORAGE_REFERENCE = Storage.storage().reference()

    public static let MY_PERMISSIONS_REQUEST_READ_MEDIA = 99;
    public static let IMAGE_UPLOAD_INTENT_REQUEST_CODE = 100;
    public static let GALLERY_INTENT_REQUEST = 101;
    public static let PROFILE_PIC_UPLOAD_INTENT_REQUEST_CODE = 102;
    
    public static let IMAGE_LOAD_THRESHOLD = 3;
    public static let IMAGE_LOAD_COUNT = 10;
    
    public static let TAG_DB = "Firebase Database"
    
    // Regex String
    public static let USERNAME_PERIOD = "."
    public static let USERNAME_PERIOD_REPLACE = "-"

    // Button Strings
    public static let BUTTON_CANCEL = "CANCEL"
    public static let BUTTON_REPOST = "REPOST"

    // Alert View Dialog Title
    public static let REPOST_MESSAGE = "This post will be shown on your profile, do you want to repost?"

}
