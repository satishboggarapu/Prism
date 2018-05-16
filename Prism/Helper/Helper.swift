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
    
    /**
     * Takes in a dataSnapshot object and parses its contents
     * and returns a prismPost object
     * @return PrismPost object
     */
    public static func constructPrismPostObject(postSnapshot: DataSnapshot) -> PrismPost {
        let prismPost = PrismPost()
        let postSnapshotdict = postSnapshot.value as? NSDictionary

        prismPost.setCaption(caption: String(describing: (postSnapshotdict?[Key.POST_DESC])!))
        prismPost.setImage(image: String(describing: (postSnapshotdict?[Key.POST_IMAGE_URI])!))
        prismPost.setTimestamp(timestamp: String(describing: (postSnapshotdict?[Key.POST_TIMESTAMP])!))
        prismPost.setUid(uid: String(describing: (postSnapshotdict?[Key.POST_UID])!))
        prismPost.setPostId(postId: postSnapshot.key)
        prismPost.setLikes(likes: Int(postSnapshot.childSnapshot(forPath: Key.DB_REF_POST_LIKED_USERS).childrenCount))
        prismPost.setReposts(reposts: Int(postSnapshot.childSnapshot(forPath: Key.DB_REF_POST_REPOSTED_USERS).childrenCount))
        
        return prismPost
    }
    
    /**
     * Takes in a dataSnapshot object and parses its contents
     * and returns a prismNotification object
     * @return PrismNotification object
     */
    public static func constructPrismNotificationObject(notificationSnapshot: DataSnapshot) -> PrismNotification {
        let prismNotification = PrismNotification()
        let notificationSnapshotDict = notificationSnapshot.value as? NSDictionary

        prismNotification.setActionTimestamp(actionTimestamp: (notificationSnapshotDict![Key.ACTION_TIMESTAMP]) as! Int64)
        prismNotification.setMostRecentUid(mostRecentUid: notificationSnapshotDict![Key.MOST_RECENT_UID] as! String)
        prismNotification.setViewedTimestamp(viewedTimestamp: notificationSnapshotDict![Key.VIEWED_TIMESTAMP] as! Int)
        prismNotification.setNotificationId(notificationId: notificationSnapshot.key)
        
       
        return prismNotification
    }
    
    
    
    /**
     * Takes in userSnapshot object and parses the firebaseUser details
     * and creates a prismUser object
     * @return PrismUser object
     */
    public static func constructPrismUserObject(userSnapshot: DataSnapshot) -> PrismUser{
        let prismUser = PrismUser()
        
        prismUser.setUid(uid: userSnapshot.key)
        prismUser.setUsername(username: String(describing: (userSnapshot.childSnapshot(forPath: Key.USER_PROFILE_USERNAME).value)!))
        prismUser.setFullName(fullName: String(describing: (userSnapshot.childSnapshot(forPath: Key.USER_PROFILE_FULL_NAME).value)!))
        prismUser.setProfilePicture(profilePicture: ProfilePicture(profilePicUriString: String(describing: (userSnapshot.childSnapshot(forPath: Key.USER_PROFILE_PIC).value)!)))

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
     * Takes in the time of the post and creates a fancy string difference
     * Examples:
     * 10 seconds ago/Just now      (time < minute)
     * 20 minutes ago               (time < hour)
     * 2 hours ago                  (time < day)
     * 4 days ago                   (time < week)
     * January 21                   (time < year)
     * September 18, 2017           (else)
     */
    public static func getFancyDateDifferenceString(time: Int64) -> String {
        let todaysDate = Date()
        let postDate = Date(milliseconds: time)

        // Convert the time to different units of times
        let secondsTime: Int64 = todaysDate.seconds(from: postDate)
        let minutesTime: Int64 = todaysDate.minutes(from: postDate)
        let hoursTime: Int64 = todaysDate.hours(from: postDate)
        let daysTime: Int64 = todaysDate.days(from: postDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        var fancyDateString = formatter.string(from: postDate)
        
        if secondsTime < MyTimeUnit.SECONDS_UNIT {
            fancyDateString = "Just now"
        } else if minutesTime < MyTimeUnit.MINUTES_UNIT {
            let fancyDateTail = (minutesTime == 1) ? " minute ago" : " minutes ago"
            fancyDateString = String(minutesTime) + fancyDateTail
        } else if hoursTime < MyTimeUnit.HOURS_UNIT {
            let fancyDateTail = (hoursTime == 1) ? " hour ago" : " hours ago"
            fancyDateString = String(hoursTime) + fancyDateTail
        } else if daysTime < MyTimeUnit.DAYS_UNIT {
            let fancyDateTail = (daysTime == 1) ? " day ago" : " days ago"
            fancyDateString = String(daysTime) + fancyDateTail
        } else if daysTime < MyTimeUnit.YEARS_UNIT {
            formatter.dateFormat = "MMM dd"
            fancyDateString = formatter.string(from: postDate)
        }
        return fancyDateString
    }
    
    /**
     * Takes a count and returns "s" (plural) if count is not equal 1
     * If count is equal to 1 it returns an empty string
     */
    public static func getSingularOrPluralString(count: Int) -> String {
        return (count == 1) ? "" : "s"
    }

    /**
     * Takes a count (number of likes) and returns the proper string for the
     * PrismPostCollectionViewCell likesLabel
     */
    public static func getLikesCountString(count: Int) -> String {
        return String(count) + " like" + getSingularOrPluralString(count: count)
    }

    /**
     * Takes a count (number of reposts) and returns the proper string for
     * the PrismPostCollectionViewCell repostsLabel
     */
    public static func getRepostsCountString(count: Int) -> String {
        return String(count) + " repost" + getSingularOrPluralString(count: count)
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
    
    /**
     * Checks to see if given prismPost has been reposted by given
     * prismUser by comparing the uid of prismPost author by given
     * prismUser. If uid's match, post author = given prismUser and
     * hence it's an upload, otherwise it is a repost
     */
    public static func isPostReposted(prismPost: PrismPost, prismUser: PrismUser) -> Bool {
        return !prismPost.getUid().elementsEqual(prismUser.getUid())
    }

    /**
     */
    public static func getImageHeightForPrismPostDetailViewController(_ image: UIImage) -> CGFloat {
        let imageWidthInPixels = Constraints.screenWidth() * UIScreen.main.scale
        let imageHeightInPixels = Constraints.screenHeight() * UIScreen.main.scale
        let imageRatio = image.size.width / image.size.height
        let imageHeight = ((imageWidthInPixels * image.size.height) / image.size.width) / UIScreen.main.scale
        return imageHeight
    }
}
