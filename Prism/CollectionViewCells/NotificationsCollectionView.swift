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
    private var usersReference: DatabaseReference = Default.USERS_REFERENCE
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.collectionViewBackground
        setupView()
        
        refreshNotificationData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
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
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .collectionViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.dropShadow()
        addSubview(tableView)
    }

    func refreshNotificationData() {
        refreshNotificationData() { (result) in
            if result {
                self.populateUserDetailsForAllNotifications() { (result) in
                    self.tableView.reloadData()
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
        let query = Default.NOTIFICATIONS_REFERENCE
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for notificationSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    let notification = Helper.constructPrismNotificationObject(notificationSnapshot: notificationSnapshot)
                    self.notificationsArrayList.append(notification)
                }
                completionHandler(true)
            } else {
                print("No More Notifications available")
                completionHandler(false)
            }
        })
    }
    
    /**
     * Once all posts are loaded into the prismPostHashMap,
     * this method iterates over each post, grabs firebaseUser's details
     * for the post like "profilePicUriString" and "username" and
     * updates the prismPost objects in that hashMap and then
     * updates the RecyclerViewAdapter so the UI gets updated
     */
    fileprivate func populateUserDetailsForAllNotifications(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        print("Inside populateUserDetailsForAllNotifications")
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for notification in self.notificationsArrayList {
                    let userSnapshot = snapshot.childSnapshot(forPath: notification.getMostRecentUid())
                    let prismUser = Helper.constructPrismUserObject(userSnapshot: userSnapshot) as PrismUser
                    notification.setPrismUser(prismUser: prismUser)
                }
                completionHandler(true)
            } else {
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
        if let range = actionId.range(of: "_") {
            let firstPartExcludingDelimiter = actionId.substring(to: range.lowerBound)
            print(firstPartExcludingDelimiter)
            prismNotification.setPostId(postId: firstPartExcludingDelimiter)
        }
    }

    
//    func setPrismUserNameForNotification(prismNotification: PrismNotification) {
//        usersReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
//            print(dataSnapshot)
//            let mostRecentUid = prismNotification.getMostRecentUid()
//            let userSnapshot: DataSnapshot = dataSnapshot.childSnapshot(forPath: mostRecentUid)
//            let prismUser : PrismUser = Helper.constructPrismUserObject(userSnapshot: userSnapshot)
//            prismNotification.setPrismUser(prismUser: prismUser)
//        }, withCancel: { (error) in
//            // TODO: Log Error
//        })
//    }

    

    

    
}

extension NotificationsCollectionView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationsTableViewCell(style: .default, reuseIdentifier: "cell")
        let prismNotification: PrismNotification = notificationsArrayList[indexPath.item]
        
        cell.delegate = self
        cell.prismNotification = prismNotification
        cell.timeLabel.text = Helper.getFancyDateDifferenceString(time: prismNotification.getActionTimestamp())
        cell.notificationActionLabel.text = parseNotificationAction(prismNotification: prismNotification).getNotificationAction()
        cell.prismUserProfilePicture.loadImageUsingUrlString(prismNotification.getPrismUser().getProfilePicture().profilePicUriString, postID: prismNotification.getPrismUser().getUid())

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("row: \(indexPath.row)")
//    }
}
//
//extension NotificationsCollectionView: NotificationsCollectionViewDelegate {
//    func prismPostSelected(_ indexPath: IndexPath) {
//        <#code#>
//    }
//    
//    
//    
//    func profileViewSelected(_ prismPost: PrismPost) {
//        delegate?.profileViewSelected(prismPost)
//    }
//}


