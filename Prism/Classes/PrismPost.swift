//
//  UserPost.swift
//  test
//
//  Created by Shiv Shah on 3/2/18.
//  Copyright © 2018 Shiv Shah. All rights reserved.
//

import Foundation

public class PrismPost: Equatable {
    
    public static func ==(lhs: PrismPost, rhs: PrismPost) -> Bool {
        return lhs.getPostId() == rhs.getPostId()
    }
    
    
    // --------------------------------------- //
    // DO NOT CHANGE ANYTHING IN THIS FILE     //
    // THESE HAVE TO BE SAME AS "POST_*" KEYS  //
    // --------------------------------------- //
    
    fileprivate var timestamp: Int64!
    fileprivate var caption: String!
    fileprivate var image: String!
    fileprivate var uid: String!
    
    // Attributes not saved in cloud
    private var likes: Int!
    private var reposts: Int!
    private var postId: String!
    private var prismUser: PrismUser!
    private var isReposted: Bool!
    
    // Empty Constructor required by Firebase to convert DataSnapshot to PrismPost.class
    public init () { }
    
    // Initializer used when creating prismPost when firebaseUser uploads the image
    public init(timestamp: Int64, postDescription: String, imageURL: String, uid: String) {
        self.timestamp = timestamp
        self.caption = postDescription
        self.image = imageURL
        self.uid = uid
    }
    
    // Getters
    public func getImage() -> String {
        return image
    }
    
    public func getCaption() -> String {
        return caption
    }
    
    public func getTimestamp() -> Int64 {
        return timestamp
    }
    
    // Try to not use this if possible, use getPrismUser().getUid() instead
    // if getPrismUser() is not null;
    public func getUid() -> String{
        return uid
    }
    
    public func getPostId() -> String {
        return postId
    }
    
    
    // Getters for attributes not saved in cloud
    public func getLikes() -> Int {
        return likes
    }
    
    public func getReposts() -> Int {
        return reposts
    }
    
    public func getPrismUser() -> PrismUser {
        return prismUser
    }
    
    public func getIsReposted() -> Bool {
        return (isReposted == nil) ? false : isReposted
    }
    
    // Setters for attributes not saved in cloud

    public func setTimestamp(timestamp : String!) {
        self.timestamp = Int64(timestamp)
    }
    
    public func setCaption(caption : String) {
        self.caption = caption
    }
    
    public func setImage(image : String) {
        self.image = image
    }
    
    public func setUid(uid : String) {
        self.uid = uid
    }
    
    public func setLikes(likes : Int) {
        self.likes = likes
    }
    
    public func setReposts(reposts : Int) {
        self.reposts = reposts
    }
    
    public func setPrismUser(prismUser : PrismUser) {
        self.prismUser = prismUser
    }
    
    public func setPostId(postId : String) {
        self.postId = postId
    }
    
    public func setIsReposted(isReposted: Bool) {
        self.isReposted = isReposted
    }
    
}



