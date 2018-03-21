//
//  Member.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class PrismUser {
    private var uid: String!
    private var username: String!
    private var fullName: String!
    private var profilePicture: ProfilePicture!
    private var followerCount : Int!
    private var followingCount : Int!
    
    public init(){ }
    
    public init(uid: String, username: String, fullName: String, profilePicture: ProfilePicture, followerCount: Int, followingCount: Int) {
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
        self.followerCount = followerCount
        self.followingCount = followingCount
    }
    
    public func getUid() -> String{
        return uid
    }
    
    public func getUsername() -> String {
        return Helper.getFirebaseDecodedUsername(encodedUsername: username)
    }
    
    public func getFullName() -> String {
        return fullName
    }
    
    public func getProfilePicture() -> ProfilePicture{
        return profilePicture
    }
    
    public func getFollowerCount() -> Int{
        return followerCount
    }
    
    public func getFollowingCount() -> Int {
        return followingCount
    }
    
    public func setUid(uid : String) {
        self.uid = uid;
    }
    
    public func setUsername(username : String) {
        self.username = username;
    }
    
    public func setFullName(fullName : String) {
        self.fullName = fullName;
    }
    
    public func setProfilePicture(profilePicture : ProfilePicture) {
        self.profilePicture = profilePicture
    }
    
    public func setFollowerCount(followerCount : Int) {
        self.followerCount = followerCount;
    }
    
    public func setFollowingCount(followingCount : Int) {
        self.followingCount = followingCount;
    }
}

