//
//  Helper.swift
//  Prism
//
//  Created by Shiv Shah on 3/7/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import Firebase

public class Helper {
    
    public static func constructPrismPostObject(postSnapshot: DataSnapshot) -> PrismPost {
        let prismPost = PrismPost()
        let postSnapshotdict = postSnapshot.value as? NSDictionary

        prismPost.setCaption(caption: String(describing: (postSnapshotdict?[Key.POST_DESC])!))
        prismPost.setImage(image: String(describing: (postSnapshotdict?[Key.POST_IMAGE_URI])!))
        prismPost.setTimestamp(timestamp: String(describing: (postSnapshotdict?[Key.POST_TIMESTAMP])!))
        prismPost.setUid(uid: String(describing: (postSnapshotdict?[Key.POST_UID])!))
        prismPost.setPostId(postId: postSnapshot.key)
        prismPost.setLikes(likes: Int(postSnapshot.childSnapshot(forPath: Key.DB_REF_USER_LIKES).childrenCount))
        prismPost.setReposts(reposts: Int(postSnapshot.childSnapshot(forPath: Key.DB_REF_USER_REPOSTS).childrenCount))
        
        print(prismPost.getTimestamp())
        return prismPost
    }
    
    public static func constructPrismUserObject(userSnapshot: DataSnapshot) -> PrismUser{
        let prismUser = PrismUser()
        prismUser.setUid(uid: userSnapshot.key)
        prismUser.setUsername(username: String(describing: userSnapshot.childSnapshot(forPath: Key.USER_PROFILE_USERNAME).value))
        prismUser.setFullName(fullName: String(describing: userSnapshot.childSnapshot(forPath: Key.USER_PROFILE_FULL_NAME).value))
        prismUser.setProfilePicture(profilePicture: ProfilePicture(profilePicUriString: (String(describing: userSnapshot.childSnapshot(forPath: Key.USER_PROFILE_PIC).value))))

        if (userSnapshot.hasChild(Key.DB_REF_USER_FOLLOWERS)) {
            prismUser.setFollowerCount(followerCount: Int(userSnapshot.childSnapshot(forPath: Key.DB_REF_USER_FOLLOWERS).childrenCount))
        } else {
            prismUser.setFollowerCount(followerCount: 0);
        }
        if (userSnapshot.hasChild(Key.DB_REF_USER_FOLLOWINGS)) {
            prismUser.setFollowingCount(followingCount: Int(userSnapshot.childSnapshot(forPath: Key.DB_REF_USER_FOLLOWINGS).childrenCount))
        } else {
            prismUser.setFollowingCount(followingCount: 0);
        }
        return prismUser;
    }
    
    /**
     * Takes the user inputted formatted usernmae and replaces the
     * period `.` character with a dash `-` so that it can be saved in firebase
     */
    public static func getFirebaseEncodedUsername(inputUsername: String) -> String {
    return inputUsername.replacingOccurrences(of: Default.USERNAME_PERIOD_REPLACE, with: Default.USERNAME_PERIOD)
    }
    
    /**
     * Takes the username stored in firebase and replaces the dash `-`
     * character with the period `.` so
     */
    public static func getFirebaseDecodedUsername(encodedUsername: String) -> String {
    return encodedUsername.replacingOccurrences(of: Default.USERNAME_PERIOD_REPLACE, with: Default.USERNAME_PERIOD)
    }
}
