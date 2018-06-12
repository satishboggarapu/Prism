//
//  CurrentUser.swift
//  Prism
//
//  Created by Shiv Shah on 3/5/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import Firebase

public class CurrentUser {
    
    /*
     * Globals
     */
    private static var auth: Auth!
    public static var firebaseUser: User!
    private static var currentUserReference: DatabaseReference!
    private static var allPostReference: DatabaseReference!

    public static var prismUser: PrismUser!
    
    /**
     * Key: String postId
     * Value: long timestamp
     **/
    public static var liked_posts_map: [String : Int64]!
    public static var reposted_posts_map: [String : Int64]!
    private static var uploaded_posts_map: [String : Int64]!
    
    /* ArrayList of PrismPost object for above structures */
    public static var liked_posts: [PrismPost]!
    public static var reposted_posts: [PrismPost]!
    public static var uploaded_posts: [PrismPost]!
    public static var uploaded_and_reposted_posts: [PrismPost]!
    
    /**
     * Key: String username
     * Value: String uid
     */
    public static var followers: [String : Int64]!
    public static var followings: [String : Int64]!

    init() {
        CurrentUser.auth = Auth.auth()
        CurrentUser.firebaseUser = CurrentUser.auth.currentUser
        CurrentUser.currentUserReference = Default.USERS_REFERENCE.child(CurrentUser.firebaseUser.uid)
        CurrentUser.allPostReference = Default.ALL_POSTS_REFERENCE;
        
        CurrentUser.refreshUserProfile()
        // TODO: Setup notifications
    }
    
    /**
     * Returns True if CurrentUser is following given PrismUser
     */
    public static func isFollowingPrismUser(_ prismUser: PrismUser) -> Bool {
        return followings.keys.contains(prismUser.getUid())
    }
    
    /**
     * Adds given prismUser to CurrentUser's followings HashMap
     */
    static func followUser(_ prismUser: PrismUser) {
        followings[prismUser.getUid()] = Date().milliseconds()
    }
    
    /**
     * Removes given PrismUser from CurrentUser's followings HashMap
     */
    static func unfollowUser(_ prismUser: PrismUser) {
        if followings.keys.contains(prismUser.getUid()) {
            followings.removeValue(forKey: prismUser.getUid())
        }
    }
    
    /**
     * Returns True if given PrismUser is a follower of CurrentUser
     */
    public static func isPrismUserFollower(_ prismUser: PrismUser) -> Bool {
        return followers.keys.contains(prismUser.getUid())
    }
    
    /**
     * Returns True if CurrentUser has liked given prismPost
     */
    public static func hasLiked(_ prismPost: PrismPost) -> Bool {
        return liked_posts != nil && liked_posts_map.keys.contains(prismPost.getPostId()!)
    }
    
    /**
     * Adds prismPost to CurrentUser's liked_posts list and hashMap
     */
    static func likePost(_ prismPost: PrismPost) {
        liked_posts.append(prismPost)
        liked_posts_map![prismPost.getPostId()!] = prismPost.getTimestamp()
    }
    
    /**
     * Adds list of liked prismPosts to CurrentUser's liked_posts list and hashMap
     */
    static func likePosts(likedPosts: [PrismPost], likePostsMap: [String: Int64]) {
        self.liked_posts.append(contentsOf: likedPosts)
        self.liked_posts_map.update(other: likePostsMap)
    }
    
    /**
     * Removes prismPost from CurrentUser's liked_posts list and hashMap
     */
    static func unlikePost(_ prismPost: PrismPost) {
        liked_posts.removeObject(prismPost)
        liked_posts_map.removeValue(forKey: prismPost.getPostId()!)
    }
    
    /**
     * Returns True if CurrentUser has reposted given prismPost
     */
    public static func hasReposted(_ prismPost: PrismPost) -> Bool {
        return reposted_posts_map != nil && reposted_posts_map.keys.contains(prismPost.getPostId()!)
    }
    
    /**
     * Adds prismPost to CurrentUser's reposted_posts list and hashMap
     */
    static func repostPost(_ prismPost: PrismPost) {
        reposted_posts.append(prismPost)
        reposted_posts_map![prismPost.getPostId()!] = prismPost.getTimestamp()
    }
    
    /**
     * Adds the list of reposted prismPosts to CurrentUser's reposted_posts list and hashMap
     */
    static func repostPosts(repostedPosts: [PrismPost], repostedPostsMap: [String: Int64]) {
        reposted_posts.append(contentsOf: repostedPosts)
        reposted_posts_map.update(other: repostedPostsMap)
        for prismPost in repostedPosts {
            prismPost.setIsReposted(isReposted: true)
        }
    }
    
    /**
     * Removes prismPost from CurrentUser's repost_posts list and hashMap
     */
    static func unrepostPost(_ prismPost: PrismPost) {
        reposted_posts.removeObject(prismPost)
        reposted_posts_map.removeValue(forKey: prismPost.getPostId()!)
    }
    
    /**
     * Adds prismPost to CurrentUser's uploaded_posts list and hashMap
     */
    static func uploadPost(_ prismPost: PrismPost) {
        uploaded_posts.append(prismPost)
        uploaded_posts_map![prismPost.getPostId()!] = prismPost.getTimestamp()
    }
    
    /**
     * Adds the list of uploaded prismPosts to CurrentUser's uploaded_posts list and hashMap
     */
    static func uploadPosts(uploadedPosts: [PrismPost], uploadedPostsMap: [String: Int64]) {
        uploaded_posts.append(contentsOf: uploadedPosts)
        uploaded_posts_map.update(other: uploadedPostsMap)
    }
    
    /**
     * Removes prismPost from CurrentUser's uploaded_posts list and hashMap
     */
    static func deletePost(_ prismPost: PrismPost) {
        uploaded_posts.removeObject(prismPost)
        uploaded_posts_map.removeValue(forKey: prismPost.getPostId()!)
    }
    
    /**
     * Creates prismUser for CurrentUser and refreshes/updates the
     * list of posts uploaded, liked, and reposted by CurrentUser.
     * Also fetches user's followers and followings.
     */
    public static func refreshUserProfile() {
        print("inside refreshUserProfile")
        liked_posts = [PrismPost]()
        reposted_posts = [PrismPost]()
        uploaded_posts = [PrismPost]()
        uploaded_and_reposted_posts = [PrismPost]()
        
        liked_posts_map = [String: Int64]()
        reposted_posts_map = [String: Int64]()
        uploaded_posts_map = [String: Int64]()
        
        followers = [String : Int64]()
        followings = [String : Int64]()
        
        DatabaseAction.fetchUserProfile()
    }
    
    // TODO: SetupNotification Method
    
    // TODO: GenerateNotification Method
    
    /**
     * Returns list of CurrentUser.uploaded_posts
     */
    public static func getUserUploads() -> [PrismPost] {
        return uploaded_posts
    }
    
    /**
     * Returns list of CurrentUser.liked_posts
     */
    public static func getUserLikes() -> [PrismPost] {
        return liked_posts
    }
    
    /**
     * Returns list of CurrentUser.reposted_posts
     */
    public static func getUserPosts() -> [PrismPost] {
        return reposted_posts
    }
    
    /**
     * Returns list of CurrentUser.uploaded_and_reposted_posts
     */
    public static func getUserUploadesAndReposts() -> [PrismPost] {
        return uploaded_and_reposted_posts
    }
    
    /**
     * Prepares combined list of CurrentUser's uploaded
     * and reposted prismPosts
     */
    static func combineUploadsAndReposts() {
        uploaded_and_reposted_posts.append(contentsOf: uploaded_posts)
        uploaded_and_reposted_posts.append(contentsOf: reposted_posts)
        
        uploaded_and_reposted_posts = uploaded_and_reposted_posts.sorted(by: { $0.getTimestamp() < $1.getTimestamp() })
    }
    
}
