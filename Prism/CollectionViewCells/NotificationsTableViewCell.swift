//
//  NotificationsTableViewCell.swift
//  Prism
//
//  Created by Shiv Shah on 5/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import Material


//protocol NotificationsTableViewCellDelegate: class {
//    func postImageSelected(_ prismPost: PrismPost)
//    func profileViewSelected(_ prismPost: PrismPost)
//}

class NotificationsTableViewCell: TableViewCell {
    
    var usernameLabel: UILabel!
    var timeLabel: UILabel!
    var notificationActionLabel: UILabel!
    var andOthersLabel: UILabel!

    var prismPostImage: CustomImageView!
    var prismUserProfilePicture: CustomImageView!
    var actionIconView: UIImageView!
    var actionImage: UIImage!
//    var actionIconFunction: UIImageView!

    
    var prismNotification: PrismNotification!
    var profilePictureSize: CGFloat = PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue
    var actionIconSize: CGFloat = 24
//    var actionIconResize: CGFloat = 20

    var viewController: MainViewController!

//    weak var delegate: NotificationsTableViewCellDelegate?



    
    // Font
    var thickFont: UIFont = SourceSansFont.light(with: 16)
    var thinFont: UIFont = SourceSansFont.extraLight(with: 16)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        initializeTimeLabel()
        initializeUsernameLabel()
        initializeAndOthersLabel()
        initializeNotificationActionLabel()
        initializePrismUserProfilePicture()
        initializePrismPostImage()
        initializeActionIcon()
//        initializeActionIconFunction()
//        contentView.backgroundColor = UIColor(hex: 0x1a1a1a)
        
        // Set top text view
        let topTextView = UIStackView()
        topTextView.alignment = .top
        topTextView.distribution = .fill
        topTextView.axis = .horizontal
        topTextView.addArrangedSubview(usernameLabel)
        topTextView.addArrangedSubview(andOthersLabel)

        // Set bottom text view
        let bottomTextView = UIStackView()
        bottomTextView.alignment = .top
        bottomTextView.distribution = .fill
        bottomTextView.axis = .horizontal
        bottomTextView.addArrangedSubview(notificationActionLabel)
        bottomTextView.addArrangedSubview(timeLabel)
        
        let textView = UIStackView()
        textView.alignment = .top
        textView.distribution = .fillEqually
        textView.axis = .vertical
        textView.addArrangedSubview(topTextView)
        textView.addArrangedSubview(bottomTextView)
        
        contentView.addSubview(textView)
        contentView.addSubview(prismUserProfilePicture)
        contentView.addSubview(prismPostImage)
        contentView.addSubview(actionIconView)
        
        let separatorLine = UIImageView()
        separatorLine.backgroundColor = .white
        contentView.addSubview(separatorLine)
        
        let separatorLineHeight = 0.25
        contentView.addConstraintsWithFormat(format: "V:|-12-[v0]-12-|", views: textView)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0(48)]-7-[v1(\(separatorLineHeight))]|", views: prismUserProfilePicture, separatorLine)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0(48)]-8-|", views: prismPostImage)
        contentView.addConstraintsWithFormat(format: "V:|-36-[v0(24)]-|", views: actionIconView)
//        contentView.addConstraintsWithFormat(format: "V:|-38-[v0(20)]-|", views: actionIconFunction)


        
        contentView.addConstraintsWithFormat(format: "H:|-8-[v0(48)]-16-[v1]-[v2(48)]-8-|", views: prismUserProfilePicture, textView, prismPostImage)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
        contentView.addConstraintsWithFormat(format: "H:|-36-[v0(24)]-|", views: actionIconView)
//        contentView.addConstraintsWithFormat(format: "H:|-38-[v0(20)]-|", views: actionIconFunction)


        
        
        
        
        contentView.backgroundColor = .collectionViewBackground
        

        
    }


    
    private func initializeUsernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.textColor = UIColor.white
        usernameLabel.font = thickFont
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "shivshah"
        usernameLabel.isUserInteractionEnabled = true
        // tap gesture
        let usernameLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(usernameLabelTapGestureAction(_:)))
        usernameLabel.addGestureRecognizer(usernameLabelTapGesture)
        
    }
    
    private func initializeAndOthersLabel() {
        andOthersLabel = UILabel()
        andOthersLabel.textColor = UIColor.white
        andOthersLabel.font = thickFont
        andOthersLabel.translatesAutoresizingMaskIntoConstraints = false
        //        contentView.addSubview(usernameLabel)
        
        andOthersLabel.isUserInteractionEnabled = true
        // tap gesture
        let andOthersLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(andOthersLabelTapGestureAction(_:)))
        andOthersLabel.addGestureRecognizer(andOthersLabelTapGesture)
        
    }
    
    private func initializeNotificationActionLabel() {
        notificationActionLabel = UILabel()
        notificationActionLabel.textColor = UIColor.white
        notificationActionLabel.font = thinFont
        notificationActionLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationActionLabel.text = "liked • "
//        contentView.addSubview(notificationActionLabel)
        
//        notificationActionLabel.isUserInteractionEnabled = true
//        // tap gesture
//        let notificationActionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationActionLabelTapGestureAction(_:)))
//        notificationActionLabel.addGestureRecognizer(notificationActionLabelTapGesture)
    }
    
    private func initializeTimeLabel() {
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = thinFont
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "2 days ago"
//        contentView.addSubview(timeLabel)
        
//        timeLabel.isUserInteractionEnabled = true
//        // tap gesture
//        let timeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeLabelTapGestureAction(_:)))
//        timeLabel.addGestureRecognizer(timeLabelTapGesture)
    }
    
    private func initializeActionIcon() {
        actionIconView = UIImageView()
        actionIconView.layer.masksToBounds = false
        actionIconView.contentMode = .center
        actionIconView.layer.backgroundColor = UIColor.black.cgColor
        actionIconView.layer.cornerRadius = actionIconSize/2
        actionIconView.clipsToBounds = true
        actionIconView.layer.borderWidth = 1
        actionIconView.layer.borderColor = UIColor.white.cgColor
        actionIconView.tintColor = .white
    }
    
//    private func initializeActionIconFunction(){
//        actionIconFunction = UIImageView()
//        actionIconFunction.layer.masksToBounds = false
//        actionIconFunction.contentMode = .scaleAspectFill
//        actionIconFunction.layer.backgroundColor = UIColor.black.cgColor
//        actionIconFunction.layer.cornerRadius = actionIconResize/2
//        actionIconFunction.clipsToBounds = true
//        actionIconFunction.tintColor = .white
//        actionIconFunction.image = #imageLiteral(resourceName: "ic_plus_circle_24dp").withRenderingMode(.alwaysTemplate)
//    }
    
    private func initializePrismPostImage() {
        prismPostImage = CustomImageView()
        prismPostImage.contentMode = .scaleAspectFill
        prismPostImage.clipsToBounds = true
        prismPostImage.translatesAutoresizingMaskIntoConstraints = false
        prismPostImage.isUserInteractionEnabled = true
//        prismPostImage.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
//        contentView.addSubview(prismPostImage)
//        prismPostImage.isUserInteractionEnabled = true
//        // tap gesture
//        let prismPostImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(prismPostImageTapGestureAction(_:)))
//        prismPostImage.addGestureRecognizer(prismPostImageTapGesture)
        
    }
    private func initializePrismUserProfilePicture() {
        prismUserProfilePicture = CustomImageView()
        prismUserProfilePicture.contentMode = .scaleAspectFit
        prismUserProfilePicture.clipsToBounds = true
        prismUserProfilePicture.translatesAutoresizingMaskIntoConstraints = false
        prismUserProfilePicture.tintColor = .white
//        prismUserProfilePicture.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
        prismUserProfilePicture.layer.cornerRadius = profilePictureSize/2


//        contentView.addSubview(prismUserProfilePicture)
        self.addBorderToProfilePic()
        prismUserProfilePicture.isUserInteractionEnabled = true
        // tap gesture
        let prismUserProfilePictureTapGesture = UITapGestureRecognizer(target: self, action: #selector(prismUserProfilePictureTapGestureAction(_:)))
        prismUserProfilePicture.addGestureRecognizer(prismUserProfilePictureTapGesture)
        
    }
    
    // MARK: Setter Methods

    public func loadProfileImage() {
        let profilePicture = prismNotification.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            prismUserProfilePicture.image = profilePicture
        } else {
            prismUserProfilePicture.loadImageUsingUrlString(prismNotification.getPrismUser().getProfilePicture().profilePicUriString, postID: prismNotification.getPrismUser().getUid())
        }
    }
    
    public func loadAndOthers() {
        let notificationQuantity = prismNotification.getPrismPost().getLikes()
        if notificationQuantity == 0{
            andOthersLabel.text = ""
        }
        else if notificationQuantity == 1{
            andOthersLabel.text = " and 1 other"
        }
        else {
            andOthersLabel.text = " and \(notificationQuantity) others"
        }
    }
    
    public func loadPostImage() {
        if prismNotification.getNotificationAction() != "followed you • " {
            let imageUrl = prismNotification.getPrismPost().getImage()
            let postId = prismNotification.getPostId()
            prismPostImage.loadImageUsingUrlString(imageUrl, postID: postId)
        }
    }
    
    private func addBorderToProfilePic() {
        prismUserProfilePicture.layer.borderWidth = 1
        prismUserProfilePicture.layer.borderColor = UIColor.white.cgColor
    }
    
    public func setActionImage(){
        let notificationAction = prismNotification.getNotificationId()
        if notificationAction.contains("_like"){
            actionIconView.image = #imageLiteral(resourceName: "ic_heart_24dp").resize(toWidth: 18)?.resize(toHeight: 18)?.withRenderingMode(.alwaysTemplate)
        }
        else if notificationAction.contains("_repost"){
            actionIconView.image = #imageLiteral(resourceName: "ic_camera_iris_24dp").resize(toWidth: 18)?.resize(toHeight: 18)?.withRenderingMode(.alwaysTemplate)
            
        }
        else if notificationAction.contains("_follow"){
            actionIconView.image = #imageLiteral(resourceName: "ic_plus_circle_24dp").resize(toWidth: 18)?.resize(toHeight: 18)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    public func setAndOthersText(){
        if prismNotification.getNotificationId().contains("_follow"){
        }
        else if prismNotification.getNotificationId().contains("like"){
            
            if prismNotification.getPrismPost().getLikes() == 2{
                andOthersLabel.text = " and \(prismNotification.getPrismPost().getLikes()-1) other"
            }
            else if prismNotification.getPrismPost().getLikes() >= 3{
                andOthersLabel.text = " and \(prismNotification.getPrismPost().getLikes()-1) others"
            }
        }
        else if prismNotification.getNotificationId().contains("repost"){
            if prismNotification.getPrismPost().getReposts() == 2{
                andOthersLabel.text = " and \(prismNotification.getPrismPost().getReposts()-1) other"
            }
            else if prismNotification.getPrismPost().getReposts() >= 3{
                andOthersLabel.text = " and \(prismNotification.getPrismPost().getReposts()-1) others"
            }
        }
    }
    
    public func setUsernameLabel(){
        usernameLabel.text = prismNotification.getPrismUser().getUsername()
    }

    

    
    
    
    // MARK: Getter Methods

    
    
    // MARK: Tap Gesture Methods

    
//    @objc func timeLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
//        print("Tapped on Time Label")
//    }
    @objc func usernameLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Username Label")
    }
    @objc func andOthersLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on And Others Label")
        let vc = LikesAndRepostsViewController()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
//    @objc func notificationActionLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
//        print("Tapped on Notification Action Label")
//    }
//    @objc func prismPostImageTapGestureAction(_ sender: UITapGestureRecognizer) {
//        print("Tapped on Prism Post Image")
//    }
    @objc func prismUserProfilePictureTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Prism User Profile Picture")
    }
    
    
    
}
