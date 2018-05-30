//
//  NotificationsTableView.swift
//  Prism
//
//  Created by Shiv Shah on 5/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Material
import MaterialComponents
import Firebase

//protocol NotificationsCollectionViewDelegate: class {
//    func prismPostSelected(_ indexPath: IndexPath)
//    func profileViewSelected(_ prismPost: PrismPost)
//}

class NotificationsCollectionView: UICollectionViewCell {
    
//    var delegate: NotificationsCollectionViewDelegate?
    
    // MARK: UIElements
    var tableView: UITableView!
    var notificationsArrayList: [PrismNotification]! = [PrismNotification]()
    var tableViewHeight: CGFloat = 64
    private var usersReference: DatabaseReference = Default.USERS_REFERENCE
    private var refreshControl: UIRefreshControl!

    var viewController: MainViewController!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.collectionViewBackground
        setupView()
        
        refreshNotificationData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        initializeNotificationsTableView()
        addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)        
        addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        
        

    }
    
    private func initializeNotificationsTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .collectionViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.dropShadow()
        
        // initialize refresh control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
        
        addSubview(tableView)
    }

    func refreshNotificationData() {
        refreshNotificationData() { (result) in
            if result {
                self.populateUserDetailsForAllNotifications() { (result) in
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } else {
                print("error loading data")
                // TODO: Log Error
            }
        }
    }
    
    

    fileprivate func refreshNotificationData(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        print("Inside refreshNotificationData")
        notificationsArrayList.removeAll()
        let query = Default.NOTIFICATIONS_REFERENCE.queryOrdered(byChild: "actionTimestamp")
        print(CurrentUser.prismUser.getUid())
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for notificationSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    let notification = Helper.constructPrismNotificationObject(notificationSnapshot: notificationSnapshot)
                    self.notificationsArrayList.insert(notification, at: 0)
                }
                completionHandler(true)
            } else {
                print("No More Notifications available")
                completionHandler(false)
            }
        })
    }
    
    fileprivate func populateUserDetailsForAllNotifications(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        print("Inside populateUserDetailsForAllNotifications")
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                Default.ALL_POSTS_REFERENCE.observeSingleEvent(of: .value, with: {(allPostsSnapshot) in
                    if allPostsSnapshot.exists(){
                        for notification in self.notificationsArrayList {
                            let userSnapshot = snapshot.childSnapshot(forPath: notification.getMostRecentUid())
                            let prismUser = Helper.constructPrismUserObject(userSnapshot: userSnapshot) as PrismUser
                            notification.setPrismUser(prismUser: prismUser)
                            self.setPrismNotificationPostId(prismNotification: notification)
                            if allPostsSnapshot.childSnapshot(forPath: notification.getPostId()).exists(){
                                let prismPost = Helper.constructPrismPostObject(postSnapshot: allPostsSnapshot.childSnapshot(forPath: notification.getPostId()))
                                print("PrismPostCreated in populateUserDetailsForAllNotifications")
                                notification.setPrismPost(prismPost: prismPost)
                            }
                            else {
                                completionHandler(false)
                            }
                        }
                    }
                    else {
                        completionHandler(false)
                    }
                })
            }
            else {
                completionHandler(false)
            }
        })
    }
    
    
    func parseNotificationAction(prismNotification: PrismNotification) -> PrismNotification{
        let action = prismNotification.getNotificationId()
        if action.contains("_like"){
            setPrismNotificationPostId(prismNotification: prismNotification)
            prismNotification.setNotificationAction(notificationAction: "liked • ")
        }
        else if action.contains("_repost"){
            setPrismNotificationPostId(prismNotification: prismNotification)
            prismNotification.setNotificationAction(notificationAction: "reposted • ")
        }
        else if action.contains("_follow"){
            prismNotification.setNotificationAction(notificationAction: "followed you • ")
        }
        else{
            prismNotification.setNotificationAction(notificationAction: "notification • ")
        }
        
        return prismNotification
    }
   
    func setPrismNotificationPostId(prismNotification: PrismNotification){
        let actionId = prismNotification.getNotificationId()
        if let range = actionId.range(of: "_like") {
            let firstPartExcludingDelimiter = actionId.substring(to: range.lowerBound)
            prismNotification.setPostId(postId: firstPartExcludingDelimiter)
        }
        if let range = actionId.range(of: "_follow") {
            let firstPartExcludingDelimiter = actionId.substring(to: range.lowerBound)
            prismNotification.setPostId(postId: firstPartExcludingDelimiter)
        }
        if let range = actionId.range(of: "_repost") {
            let firstPartExcludingDelimiter = actionId.substring(to: range.lowerBound)
            prismNotification.setPostId(postId: firstPartExcludingDelimiter)
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        print("refreshed")
        CurrentUser.refreshUserProfile()
        refreshNotificationData()
    }
}

extension NotificationsCollectionView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notificationsArrayList.count)
        return notificationsArrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationsTableViewCell(style: .default, reuseIdentifier: "cell")
        print(notificationsArrayList.count)
        let prismNotification: PrismNotification = notificationsArrayList[indexPath.item]
        cell.viewController = viewController
        cell.prismNotification = prismNotification
        cell.timeLabel.text = Helper.getFancyDateDifferenceString(time: prismNotification.getActionTimestamp())
        cell.notificationActionLabel.text = parseNotificationAction(prismNotification: prismNotification).getNotificationAction()
        cell.loadProfileImage()
        cell.loadPostImage()
        cell.setUsernameLabel()
        cell.setAndOthersText()
        cell.setActionImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight
    }
}


