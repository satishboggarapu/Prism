//
//  PrismNotification.swift
//  Prism
//
//  Created by Shiv Shah on 5/11/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class PrismNotification: Equatable {
    
    public static func ==(lhs: PrismNotification, rhs: PrismNotification) -> Bool {
        return lhs.getNotificationId() == rhs.getNotificationId()
    }
    
    // --------------------------------------- //
    // DO NOT CHANGE ANYTHING IN THIS FILE     //
    // THESE HAVE TO BE SAME AS "POST_*" KEYS  //
    // --------------------------------------- //
    
    fileprivate var notificationId: String!
    fileprivate var actionTimestamp: Int64!
    fileprivate var mostRecentUid: String!
    fileprivate var viewedTimestamp: Int!

    private var prismUser: PrismUser!
    private var notificationAction: String!
    private var image: String!
    private var postId: String!


    

    // Empty Constructor required by Firebase to convert DataSnapshot to PrismNotification.class
    public init () { }
    
    // Initializer used when creating prismPost when firebaseUser uploads the image
    public init(notificationId: String, actionTimestamp: Int64, mostRecentUid: String, viewedTimestamp: Int) {
        self.notificationId = notificationId
        self.actionTimestamp = actionTimestamp
        self.mostRecentUid = mostRecentUid
        self.viewedTimestamp = viewedTimestamp
    }
    
    // Getters
    public func getNotificationId() -> String {
        return notificationId
    }
    
    public func getActionTimestamp() -> Int64 {
        return actionTimestamp
    }
    
    public func getMostRecentUid() -> String {
        return mostRecentUid
    }
    
    public func getViewedTimestamp() -> Int {
        return viewedTimestamp
    }
    
    
    // Getters for attributes not saved in cloud
    public func getNotificationAction() -> String {
        return notificationAction
    }
    
    public func getPrismUser() -> PrismUser {
        return prismUser
    }
    
    public func getImage() -> String {
        return image
    }
    public func getPostId() -> String {
        return postId
    }
    
    
    // Setters for attributes not saved in cloud
    
    public func setNotificationId(notificationId : String!) {
        self.notificationId = notificationId
    }
    
    public func setActionTimestamp(actionTimestamp : Int64!) {
        self.actionTimestamp = actionTimestamp
    }
    
    public func setMostRecentUid(mostRecentUid : String!) {
        self.mostRecentUid = mostRecentUid
    }
    
    public func setViewedTimestamp(viewedTimestamp : Int!) {
        self.viewedTimestamp = viewedTimestamp
    }
    
    public func setNotificationAction(notificationAction : String!) {
        self.notificationAction = notificationAction
    }
    
    public func setImage(image : String) {
        self.image = image
    }
    
    public func setPrismUser(prismUser : PrismUser) {
        self.prismUser = prismUser
    }
    
    public func setPostId(postId : String) {
        self.postId = postId
    }
}



