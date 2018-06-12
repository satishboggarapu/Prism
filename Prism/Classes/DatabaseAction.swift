//
// Created by Satish Boggarapu on 3/20/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import Firebase

public class DatabaseAction {

    private static var currentUserId: String = CurrentUser.firebaseUser.uid
    private static var currentUsername: String = CurrentUser.firebaseUser.displayName!
    private static var currentUserReference: DatabaseReference = Default.USERS_REFERENCE.child(DatabaseAction.currentUserId)
    private static var allPostReference: DatabaseReference = Default.ALL_POSTS_REFERENCE
    private static var usersReference: DatabaseReference = Default.USERS_REFERENCE
    
    /**
     * Adds prismPost to CurrentUser's USER_LIKES section
     * Adds userId to prismPost's LIKED_USERS section
     * Performs like locally on CurrentUser
     */
    public static func performLike(_ prismPost: PrismPost) {
        let postId: String = prismPost.getPostId()!
        let actionTimestamp: Int64 = Date().milliseconds()
        let postReference: DatabaseReference = allPostReference.child(postId)
        
        postReference.child(Key.DB_REF_POST_LIKED_USERS).child(currentUserId).setValue(actionTimestamp)
        currentUserReference.child(Key.DB_REF_USER_LIKES).child(postId).setValue(actionTimestamp)
        CurrentUser.likePost(prismPost)
        
        // TODO: Notification
    }
    
    // TODO: updateNotification()
    
    /**
     * Removes prismPost to CurrentUser's USER_LIKES section
     * Removes userId to prismPost's LIKED_USERS section
     * Performs unlike locally on CurrentUser*
     */
    public static func performUnlike(_ prismPost: PrismPost) {
        let postId: String = prismPost.getPostId()!
        let postReference: DatabaseReference = allPostReference.child(postId)
        let timerstamp: Int64 = Date().milliseconds()
        
        postReference.child(Key.DB_REF_POST_LIKED_USERS).child(currentUserId).removeValue()
        currentUserReference.child(Key.DB_REF_USER_LIKES).child(postId).removeValue()
        CurrentUser.unlikePost(prismPost)
        
        // TODO: Notification
    }
    
    /**
     * Adds prismPost to CurrentUser's USER_REPOSTS section
     * Adds userId to prismPost's REPOSTED_USERS section
     * Performs repost locally on CurrentUser
     */
    public static func performRepost(_ prismPost: PrismPost) {
        let postId: String = prismPost.getPostId()!
        let timestamp: Int64 = Date().milliseconds()
        let postReference: DatabaseReference = allPostReference.child(postId)
        
        postReference.child(Key.DB_REF_POST_REPOSTED_USERS).child(currentUserId).setValue(timestamp)
        currentUserReference.child(Key.DB_REF_USER_REPOSTS).child(postId).setValue(timestamp)
        CurrentUser.repostPost(prismPost)
        
        // TODO: Notification
    }
    
    /**
     * Removes prismPost to CurrentUser's USER_REPOSTS section
     * Removes userId to prismPost's REPOSTED_USERS section
     * Performs unrepost locally on CurrentUser
     */
    public static func performUnrepost(_ prismPost: PrismPost) {
        let postId: String = prismPost.getPostId()!
        let postReference: DatabaseReference = allPostReference.child(postId)
        
        postReference.child(Key.DB_REF_POST_REPOSTED_USERS).child(currentUserId).removeValue()
        currentUserReference.child(Key.DB_REF_USER_REPOSTS).child(postId).removeValue()
        CurrentUser.unrepostPost(prismPost)
    }
    
    /**
     * Removes prismPost image from Firebase Storage. When that task is
     * successfully completed, the likers and reposters for the post
     * are fetched and the postId is deleted under each liker and reposter's
     * USER_LIKES and USER_REPOSTS section. Then the post is deleted under
     * USER_UPLOADS for the post owner. And then the post itself is
     * deleted from ALL_POSTS. Finally, the mainRecyclerViewAdapter is refreshed
     */
    public static func deletePost(_ prismPost: PrismPost, completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        // TODO: Delete post
        Storage.storage().reference(forURL: prismPost.getImage()).delete(completion: { (error) in
            if error == nil {
                let postId: String = prismPost.getPostId()!
                allPostReference.child(postId).observeSingleEvent(of: .value, with: { (postSnapshot) in
                    if postSnapshot.exists() {
                        DeleteHelper.deleteLikedUsers(postSnapshot: postSnapshot, post: prismPost)
                        DeleteHelper.deleteRepostedUsers(postSnapshot: postSnapshot, prismPost: prismPost)
                        usersReference.child((prismPost.getPrismUser()?.getUid())!).child(Key.DB_REF_USER_UPLOADS).child(postId).removeValue()
                        allPostReference.child(postId).removeValue()
                        
                        CurrentUser.deletePost(prismPost)
                        
                        // TODO: Update UI
                        completionHandler(true)
                    } else {
                        // TODO: Log Error
                        completionHandler(false)
                    }
                }, withCancel : { (error) in
                    // TODO: Log Error
                    completionHandler(false)
                })
            } else {
//                 TODO: Log Error
                completionHandler(false)
            }
        })
    }
    
    /**
     * Adds prismUser's uid to CurrentUser's FOLLOWERS section and then
     * adds CurrentUser's uid to prismUser's FOLLOWINGS section
     */
    public static func followUser(_ prismUser: PrismUser) {
        let userReference: DatabaseReference = usersReference.child(prismUser.getUid())
        let timestamp: Int64 = Date().milliseconds()
        userReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if dataSnapshot.exists() {
                userReference.child(Key.DB_REF_USER_FOLLOWERS).child(CurrentUser.prismUser.getUid())
                currentUserReference.child(Key.DB_REF_USER_FOLLOWINGS).child(prismUser.getUid()).setValue(timestamp)
                CurrentUser.followUser(prismUser)
            } else {
                // TODO: Log Error
            }
        }, withCancel: { (error) in
            // TODO: Log Error
        })
    }
    
    /**
     * Removes prismUser's uid from CurrentUser's FOLLOWERS section and then
     * removes CurrentUser's uid from prismUser's FOLLOWINGS section
     */
    public static func unfollowUser(_ prismUser: PrismUser) {
        let userReference: DatabaseReference = usersReference.child(prismUser.getUid())
        userReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if dataSnapshot.exists() {
                userReference.child(Key.DB_REF_USER_FOLLOWERS).child(CurrentUser.prismUser.getUid()).removeValue()
                currentUserReference.child(Key.DB_REF_USER_FOLLOWINGS).child(prismUser.getUid()).removeValue()
                CurrentUser.unfollowUser(prismUser)
            } else {
                // TODO: Log Error
            }
        }, withCancel: { (error) in
            // TODO: Log Error
        })
    }
    
    /**
     * Creates prismUser for CurrentUser
     * Then fetches CurrentUser's liked, reposted and uploaded posts
     * And then refresh the mainRecyclerViewAdapter
     */
    static func fetchUserProfile() {
        print("inside fetchUserProfile")
        var likedPostMap: [String: Int64] = [String: Int64]()
        var repostedPostsMap: [String: Int64] = [String: Int64]()
        var uploadedPostsMap: [String: Int64] = [String: Int64]()
        
        usersReference.observeSingleEvent(of: .value, with: { (usersSnapshot) in
            if usersSnapshot.exists() {
                CurrentUser.prismUser = Helper.constructPrismUserObject(userSnapshot: usersSnapshot.childSnapshot(forPath: CurrentUser.firebaseUser.uid))
                let currentUserSnapshot: DataSnapshot = usersSnapshot.childSnapshot(forPath: CurrentUser.prismUser.getUid())

                if currentUserSnapshot.hasChild(Key.DB_REF_USER_LIKES) {
                    likedPostMap.update(other: currentUserSnapshot.childSnapshot(forPath: Key.DB_REF_USER_LIKES).value as! [String : Int64])
                }
                if currentUserSnapshot.hasChild(Key.DB_REF_USER_REPOSTS) {
                    repostedPostsMap.update(other: currentUserSnapshot.childSnapshot(forPath: Key.DB_REF_USER_REPOSTS).value as! [String: Int64])
                }
                if currentUserSnapshot.hasChild(Key.DB_REF_USER_UPLOADS) {
                    uploadedPostsMap.update(other: currentUserSnapshot.childSnapshot(forPath: Key.DB_REF_USER_UPLOADS).value as! [String: Int64])
                }
                if currentUserSnapshot.hasChild(Key.DB_REF_USER_FOLLOWERS) {
                    // had a problem with casting json to [String: String], so I changed it to [String: Any]
                    CurrentUser.followers.update(other: currentUserSnapshot.childSnapshot(forPath: Key.DB_REF_USER_FOLLOWERS).value as! [String: Int64])
                }
                
                if currentUserSnapshot.hasChild(Key.DB_REF_USER_FOLLOWINGS) {
                    CurrentUser.followings.update(other: currentUserSnapshot.childSnapshot(forPath: Key.DB_REF_USER_FOLLOWINGS).value as! [String: Int64])
                }
                
                allPostReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    let userLikes: [PrismPost] = getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: likedPostMap)
                    let userReposts: [PrismPost] = getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: repostedPostsMap)
                    let userUploads: [PrismPost] = getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: uploadedPostsMap)
                    
                    CurrentUser.likePosts(likedPosts: userLikes, likePostsMap: likedPostMap)
                    CurrentUser.repostPosts(repostedPosts: userReposts, repostedPostsMap: repostedPostsMap)
                    CurrentUser.uploadPosts(uploadedPosts: userUploads, uploadedPostsMap: uploadedPostsMap)
                    CurrentUser.combineUploadsAndReposts()
                }, withCancel: { (error) in
                    // TODO: Log Error
                })
            }
        }, withCancel: { (error) in
            // TODO: Log Error
        })
    }
    
    /**
     * Takes in a hashMap of prismPost postIds and also takes in dataSnapshot
     * referencing to `ALL_POSTS` and `USERS` and constructs PrismPost objects
     * for each postId in the hashMap and puts all prismPost objects in a list.
     * Gets called for getting user liked_posts, reposted_posts, and uploaded_posts
     */
    static func getListOfPrismPosts(allPostRefSnapshot: DataSnapshot, usersSnapshot: DataSnapshot, mapOfPostIds: [String: Int64]) -> [PrismPost] {
        var listOfPrismPosts = [PrismPost]()
        for key in mapOfPostIds.keys {
            let postId: String = String(key)
            let postSnapshot: DataSnapshot = allPostRefSnapshot.childSnapshot(forPath: postId)
            
            if postSnapshot.exists() {
                let prismPost: PrismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot)
                let userSnapshot: DataSnapshot = usersSnapshot.childSnapshot(forPath: prismPost.getUid())
                let prismUser: PrismUser = Helper.constructPrismUserObject(userSnapshot: userSnapshot)
                prismPost.setPrismUser(prismUser: prismUser)
                
                listOfPrismPosts.append(prismPost)
            }
        }
        return listOfPrismPosts
    }
    
}

class DeleteHelper {
    private static let usersReference: DatabaseReference = Default.USERS_REFERENCE
    
    /**
     * Helper method that goes to all users who have liked the given
     * prismPost and deletes the postId under their USER_LIKES section
     */
    static func deleteLikedUsers(postSnapshot: DataSnapshot, post: PrismPost) {
        var likedUsers: [String: Int64] = [String: Int64]()
        if postSnapshot.childSnapshot(forPath: Key.DB_REF_POST_LIKED_USERS).childrenCount > 0 {
            likedUsers.update(other: postSnapshot.childSnapshot(forPath: Key.DB_REF_POST_LIKED_USERS).value as! [String: Int64])
            for userId in likedUsers.keys {
                usersReference.child(userId).child(Key.DB_REF_USER_LIKES).child(post.getPostId()!).removeValue()
            }
        }
    }
    
    /**
     * Helper method that goes to all users who have reposted the given
     * prismPost and deletes the postId under their USER_REPOSTS section
     */
    static func deleteRepostedUsers(postSnapshot: DataSnapshot, prismPost: PrismPost) {
        var repostedUsers: [String: Int64] = [String: Int64]()
        if postSnapshot.childSnapshot(forPath: Key.DB_REF_POST_REPOSTED_USERS).childrenCount > 0 {
            repostedUsers.update(other: postSnapshot.childSnapshot(forPath: Key.DB_REF_POST_REPOSTED_USERS).value as! [String: Int64])
            for userId in repostedUsers.keys {
                usersReference.child(userId).child(Key.DB_REF_USER_REPOSTS).child(prismPost.getPostId()!).removeValue()
            }
        }
    }
}
